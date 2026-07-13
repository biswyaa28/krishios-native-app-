import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF154212);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF2D5A27);
  static const onPrimaryContainer = Color(0xFF9DD090);
  static const primaryFixed = Color(0xFFBCF0AE);
  static const primaryFixedDim = Color(0xFFA1D494);
  static const onPrimaryFixed = Color(0xFF002201);
  static const onPrimaryFixedVariant = Color(0xFF23501E);

  static const secondary = Color(0xFF7A5649);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFDCDBC);
  static const onSecondaryContainer = Color(0xFF795548);
  static const secondaryFixed = Color(0xFFFFDBCF);
  static const secondaryFixedDim = Color(0xFFEBBCAC);
  static const onSecondaryFixed = Color(0xFF2E150B);
  static const onSecondaryFixedVariant = Color(0xFF603F33);

  static const tertiary = Color(0xFF4F3500);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF6C4A00);
  static const onTertiaryContainer = Color(0xFFFFB51E);
  static const tertiaryFixed = Color(0xFFFFDEAC);
  static const tertiaryFixedDim = Color(0xFFFFBA38);
  static const onTertiaryFixed = Color(0xFF281900);
  static const onTertiaryFixedVariant = Color(0xFF604100);

  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  static const background = Color(0xFFF8FAF5);
  static const onBackground = Color(0xFF191C1A);
  static const surface = Color(0xFFF8FAF5);
  static const onSurface = Color(0xFF191C1A);
  static const surfaceVariant = Color(0xFFE1E3DE);
  static const onSurfaceVariant = Color(0xFF42493E);
  static const surfaceDim = Color(0xFFD8DBD6);
  static const surfaceBright = Color(0xFFF8FAF5);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2F4EF);
  static const surfaceContainer = Color(0xFFECEFEA);
  static const surfaceContainerHigh = Color(0xFFE7E9E4);
  static const surfaceContainerHighest = Color(0xFFE1E3DE);

  static const outline = Color(0xFF72796E);
  static const outlineVariant = Color(0xFFC2C9BB);

  static const inverseSurface = Color(0xFF2E312E);
  static const inverseOnSurface = Color(0xFFEFF1EC);
  static const inversePrimary = Color(0xFFA1D494);

  // Dark theme colors
  static const darkScaffoldBackground = Color(0xFF0E1310);
  static const darkSurface = Color(0xFF1A1E1A);
  static const darkOnSurface = Color(0xFFE2E3DE);
  static const darkSurfaceContainerHighest = Color(0xFF2D322D);
  static const darkOnPrimary = Color(0xFF0A3A08);
  static const darkOnSecondary = Color(0xFF442A1E);
  static const darkOnTertiary = Color(0xFF3D2800);
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkOutline = Color(0xFF8C9386);
}

class AppTextStyles {
  static const TextStyle headlineLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.02,
  );

  static const TextStyle headlineLgMobile = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.01,
  );

  static const TextStyle headlineMd = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  static const TextStyle labelMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.01,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.04,
  );
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      inversePrimary: AppColors.inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainer,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSm.copyWith(
              color: AppColors.onPrimaryContainer,
            );
          }
          return AppTextStyles.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.onPrimaryContainer,
            );
          }
          return const IconThemeData(
            color: AppColors.onSurfaceVariant,
          );
        }),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.inversePrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.onPrimaryFixedVariant,
        onPrimaryContainer: AppColors.primaryFixed,
        secondary: AppColors.secondaryFixedDim,
        onSecondary: AppColors.darkOnSecondary,
        secondaryContainer: AppColors.onSecondaryFixedVariant,
        onSecondaryContainer: AppColors.secondaryContainer,
        tertiary: AppColors.tertiaryFixedDim,
        onTertiary: AppColors.darkOnTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.tertiaryFixed,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        errorContainer: AppColors.onErrorContainer,
        onErrorContainer: AppColors.errorContainer,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
        onSurfaceVariant: AppColors.outlineVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.onSurfaceVariant,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.onPrimaryFixedVariant,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.labelSm.copyWith(
              color: AppColors.primaryFixed,
            );
          }
          return AppTextStyles.labelSm.copyWith(
            color: AppColors.outlineVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primaryFixed,
            );
          }
          return const IconThemeData(
            color: AppColors.outlineVariant,
          );
        }),
      ),
    );
  }
}
