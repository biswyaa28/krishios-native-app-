import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/services/hive_service.dart';
import '../theme/app_theme.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_loadThemeMode());

  static ThemeMode _loadThemeMode() {
    final box = HiveService.getUserPrefsBox();
    final isDark = box.get('dark_mode', defaultValue: false);
    AppColors.updateTheme(isDark);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    AppColors.updateTheme(isDark);
    state = mode;
    final box = HiveService.getUserPrefsBox();
    box.put('dark_mode', isDark);
  }

  void toggle() {
    setThemeMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
