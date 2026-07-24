import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/weather.dart';
import '../models/scan_result.dart';

class HiveService {
  static const String weatherBox = 'weather_cache';
  static const String scanHistoryBox = 'scan_history';
  static const String userPrefsBox = 'user_prefs';
  static const String draftsBox = 'community_drafts';
  static const String tasksBox = 'tasks';

  static const String _secureStorageKey = 'hive_encryption_key';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<void> init() async {
    try {
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        // Clean up lock files
        for (final name in [weatherBox, scanHistoryBox, userPrefsBox, draftsBox, tasksBox, 'app_notifications']) {
          final lock = File('${dir.path}/$name.lock');
          if (await lock.exists()) {
            try { await lock.delete(); } catch (_) {}
          }
        }
      }
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(WeatherAdapter());
      if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ScanResultAdapter());

      // Fetch or generate cryptographically secure 32-byte AES key via FlutterSecureStorage
      List<int>? keyBytes;
      try {
        final storedKeyStr = await _secureStorage.read(key: _secureStorageKey);
        if (storedKeyStr != null) {
          final decoded = base64Url.decode(storedKeyStr);
          if (decoded.length == 32) {
            keyBytes = decoded;
          }
        }
      } catch (_) {
        keyBytes = null;
      }

      // Generate a new 32-byte key if missing or invalid
      if (keyBytes == null || keyBytes.length != 32) {
        keyBytes = Hive.generateSecureKey();
        try {
          await _secureStorage.write(
            key: _secureStorageKey,
            value: base64Url.encode(keyBytes),
          );
        } catch (_) {}
      }

      final cipher = HiveAesCipher(keyBytes);

      await Hive.openBox<Weather>(weatherBox, encryptionCipher: cipher);
      await Hive.openBox<ScanResult>(scanHistoryBox, encryptionCipher: cipher);
      await Hive.openBox(userPrefsBox, encryptionCipher: cipher);
      await Hive.openBox(draftsBox, encryptionCipher: cipher);
      await Hive.openBox(tasksBox, encryptionCipher: cipher);
      await Hive.openBox('app_notifications');
    } catch (e) {
      // Graceful error recovery: Open unencrypted fallback boxes if platform keystore is unavailable
      await Hive.initFlutter();
      await Hive.openBox<Weather>(weatherBox);
      await Hive.openBox<ScanResult>(scanHistoryBox);
      await Hive.openBox(userPrefsBox);
      await Hive.openBox(draftsBox);
      await Hive.openBox(tasksBox);
      await Hive.openBox('app_notifications');
    }
  }

  static Box<Weather> getWeatherBox() => Hive.box<Weather>(weatherBox);
  static Box<ScanResult> getScanHistoryBox() => Hive.box<ScanResult>(scanHistoryBox);
  static Box getUserPrefsBox() => Hive.box(userPrefsBox);
  static Box getDraftsBox() => Hive.box(draftsBox);
  static Box getTasksBox() => Hive.box(tasksBox);
}
