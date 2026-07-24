import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'farmer',
      avatarUrl: data['avatarUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
