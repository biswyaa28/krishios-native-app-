import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:krishios/shared/models/scan_result.dart';
import 'package:krishios/shared/services/hive_service.dart';

class ScanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ScanResult> getScanHistory() {
    final box = HiveService.getScanHistoryBox();
    final scans = box.values.toList();
    scans.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    
    // Asynchronously trigger Firestore fetch to update the local Hive cache
    _syncFirestoreScansInBackground();

    return scans;
  }

  Future<void> addScan(ScanResult scan) async {
    // 1. Save locally to Hive immediately
    final box = HiveService.getScanHistoryBox();
    await box.put(scan.id, scan);

    // 2. Upload to Cloud Firestore if online & authenticated
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('scans')
            .doc(scan.id)
            .set({
          'id': scan.id,
          'cropName': scan.cropName,
          'fieldName': scan.fieldName,
          'diagnosis': scan.diagnosis,
          'healthScore': scan.healthScore,
          'scannedAt': Timestamp.fromDate(scan.scannedAt),
          'imagePath': scan.imagePath,
          'confidence': scan.confidence,
          'treatment': scan.treatment,
          'latitude': scan.latitude,
          'longitude': scan.longitude,
          'userId': user.uid,
        });
      } catch (e) {
        print('[ERROR] Failed to save scan to Firestore: $e');
      }
    }
  }

  Future<void> deleteScan(String id) async {
    // 1. Delete from Hive
    final box = HiveService.getScanHistoryBox();
    await box.delete(id);

    // 2. Delete from Firestore
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('scans')
            .doc(id)
            .delete();
      } catch (_) {}
    }
  }

  double getAverageHealthScore() {
    final scans = getScanHistory();
    if (scans.isEmpty) return 0;
    return scans.map((s) => s.healthScore).reduce((a, b) => a + b) / scans.length;
  }

  int getWeeklyScanCount() {
    final scans = getScanHistory();
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return scans.where((s) => s.scannedAt.isAfter(weekAgo)).length;
  }

  Future<void> _syncFirestoreScansInBackground() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('scans')
          .get();

      final box = HiveService.getScanHistoryBox();
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final scan = ScanResult(
          id: doc.id,
          cropName: data['cropName'] ?? '',
          fieldName: data['fieldName'] ?? '',
          diagnosis: data['diagnosis'] ?? '',
          healthScore: (data['healthScore'] as num?)?.toDouble() ?? 0.0,
          scannedAt: (data['scannedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          imagePath: data['imagePath'],
          confidence: (data['confidence'] as num?)?.toDouble(),
          treatment: data['treatment'],
          latitude: (data['latitude'] as num?)?.toDouble(),
          longitude: (data['longitude'] as num?)?.toDouble(),
          userId: user.uid,
        );
        await box.put(scan.id, scan);
      }
    } catch (_) {}
  }
}
