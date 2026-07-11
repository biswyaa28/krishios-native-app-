import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((ref) => ScanRepository());

final scanHistoryProvider = Provider<List>((ref) {
  return ref.watch(scanRepositoryProvider).getScanHistory();
});

final averageHealthProvider = Provider<double>((ref) {
  return ref.watch(scanRepositoryProvider).getAverageHealthScore();
});

final weeklyScanCountProvider = Provider<int>((ref) {
  return ref.watch(scanRepositoryProvider).getWeeklyScanCount();
});
