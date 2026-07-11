import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/weather.dart';
import '../models/scan_result.dart';

class HiveService {
  static const String weatherBox = 'weather_cache';
  static const String scanHistoryBox = 'scan_history';
  static const String userPrefsBox = 'user_prefs';
  static const String draftsBox = 'community_drafts';

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    // Clean up locks
    for (final name in [weatherBox, scanHistoryBox, userPrefsBox, draftsBox, 'secure_keys_box']) {
      final lock = File('${dir.path}/$name.lock');
      if (await lock.exists()) {
        try { await lock.delete(); } catch (_) {}
      }
    }
    await Hive.initFlutter();
    Hive.registerAdapter(WeatherAdapter());
    Hive.registerAdapter(ScanResultAdapter());

    // Open secure key container (unencrypted metadata storage)
    final secureBox = await Hive.openBox('secure_keys_box');
    List<int>? key = secureBox.get('encryption_key')?.cast<int>();
    if (key == null) {
      key = Hive.generateSecureKey();
      await secureBox.put('encryption_key', key);
    }

    final cipher = HiveAesCipher(key);

    await Hive.openBox<Weather>(weatherBox, encryptionCipher: cipher);
    await Hive.openBox<ScanResult>(scanHistoryBox, encryptionCipher: cipher);
    await Hive.openBox(userPrefsBox, encryptionCipher: cipher);
    await Hive.openBox(draftsBox, encryptionCipher: cipher);
  }

  static Box<Weather> getWeatherBox() => Hive.box<Weather>(weatherBox);
  static Box<ScanResult> getScanHistoryBox() => Hive.box<ScanResult>(scanHistoryBox);
  static Box getUserPrefsBox() => Hive.box(userPrefsBox);
  static Box getDraftsBox() => Hive.box(draftsBox);
}
