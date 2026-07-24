import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/models/scan_result.dart';
import 'package:krishios/shared/services/ai_engine_manager.dart';
import 'package:krishios/shared/services/hive_service.dart';
import 'package:krishios/core/constants/api_constants.dart';
import '../../data/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((ref) => ScanRepository());

final aiEngineManagerProvider = ChangeNotifierProvider<AIEngineManager>((ref) {
  final prefs = HiveService.getUserPrefsBox();
  final savedHost = prefs.get('backend_host', defaultValue: null) as String?;
  final override = kIsWeb ? 'localhost' : (savedHost ?? ApiConstants.overrideHost);
  final host = override ?? 'localhost';

  final manager = AIEngineManager(
    scanBaseUrl: ApiConstants.scanBaseUrl,
    host: host,
  );

  // Initialize engine session
  manager.initialize();

  ref.onDispose(() => manager.dispose());
  return manager;
});

final scanHistoryProvider = Provider<List<ScanResult>>((ref) {
  return ref.watch(scanRepositoryProvider).getScanHistory();
});

final averageHealthProvider = Provider<double>((ref) {
  return ref.watch(scanRepositoryProvider).getAverageHealthScore();
});

final weeklyScanCountProvider = Provider<int>((ref) {
  return ref.watch(scanRepositoryProvider).getWeeklyScanCount();
});
