import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ProviderScope;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:krishios/shared/services/kavya/context_manager.dart';
import 'package:krishios/shared/services/hive_service.dart';
import 'package:krishios/shared/models/scan_result.dart';
import 'package:krishios/features/scan/presentation/providers/scan_provider.dart';
import 'package:krishios/features/weather/presentation/providers/weather_provider.dart';

final _contextProvider =
    FutureProvider.family<Map<String, dynamic>, String?>((ref, scanId) async {
  final cm = ContextManager(ref);
  return cm.buildContext(scanId);
});

void main() {
  setUp(() async {
    final dir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(dir.path);
    await Hive.openBox(HiveService.userPrefsBox);
    final prefs = Hive.box(HiveService.userPrefsBox);
    await prefs.put('selected_language', 'en');
  });

  tearDown(() {
    Hive.deleteBoxFromDisk(HiveService.userPrefsBox);
  });

  test('ContextManager builds context with language and time when scan/weather are unavailable', () async {
    final container = ProviderContainer(
      overrides: [
        scanHistoryProvider.overrideWith((ref) => <ScanResult>[]),
        averageHealthProvider.overrideWith((ref) => 0.0),
      ],
    );

    addTearDown(() => container.dispose());

    final context = await container.read(_contextProvider(null).future);

    expect(context['languageCode'], 'en');
    expect(context['totalScans'], 0);
    expect(context.containsKey('timeGreeting'), true);
    expect(context.containsKey('weatherTemp'), false);
    expect(context.containsKey('cropName'), false);
  });

  test('ContextManager handles weather provider gracefully when unavailable', () async {
    final container = ProviderContainer(
      overrides: [
        scanHistoryProvider.overrideWith((ref) => <ScanResult>[]),
        averageHealthProvider.overrideWith((ref) => 0.0),
        positionProvider.overrideWith((ref) async => null),
      ],
    );

    addTearDown(() => container.dispose());

    final context = await container.read(_contextProvider(null).future);

    expect(context['languageCode'], 'en');
    expect(context.containsKey('weatherTemp'), isFalse);
    expect(context['totalScans'], 0);
  });
}
