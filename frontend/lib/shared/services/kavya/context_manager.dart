import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/features/scan/presentation/providers/scan_provider.dart';
import 'package:krishios/features/weather/presentation/providers/weather_provider.dart';
import 'package:krishios/shared/models/scan_result.dart';

class ContextManager {
  final Ref _ref;

  ContextManager(this._ref);

  Future<Map<String, dynamic>> buildContext(String? scanId) async {
    final context = <String, dynamic>{};

    // 1. Language Preference
    final language = _ref.read(languageProvider);
    context['languageCode'] = language;

    // 2. Scan Context
    final scanHistory = _ref.read(scanHistoryProvider);
    ScanResult? activeScan;
    if (scanId != null && scanId.isNotEmpty && scanId != 'general') {
      try {
        activeScan = scanHistory.firstWhere((s) => s.id == scanId);
      } catch (_) {}
    } else if (scanHistory.isNotEmpty) {
      activeScan = scanHistory.first;
    }

    if (activeScan != null) {
      context['scanId'] = activeScan.id;
      context['cropName'] = activeScan.cropName;
      context['diagnosis'] = activeScan.diagnosis;
      context['confidence'] = activeScan.confidence;
      context['severity'] = activeScan.healthScore < 40
          ? 'Severe'
          : (activeScan.healthScore < 80 ? 'Moderate' : 'Mild');
    }

    // 3. Previous Scans Count & Average Health
    context['totalScans'] = scanHistory.length;
    context['averageHealth'] = _ref.read(averageHealthProvider);

    // 4. Weather Context (properly awaits the FutureProvider)
    try {
      final weather = await _ref.read(weatherProvider.future);
      if (weather != null) {
        context['weatherTemp'] = weather.temperature;
        context['weatherHumidity'] = weather.humidity;
        context['weatherPrecipitation'] = weather.precipitation;
      }
    } catch (_) {
      // Weather unavailable — proceed without it
    }

    // 5. Time of day details
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      context['timeGreeting'] = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      context['timeGreeting'] = 'Good Afternoon';
    } else {
      context['timeGreeting'] = 'Good Evening';
    }

    return context;
  }
}
