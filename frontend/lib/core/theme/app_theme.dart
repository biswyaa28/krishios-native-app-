import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFF154212);
  static Color onPrimary = const Color(0xFFFFFFFF);
  static Color primaryContainer = const Color(0xFF2D5A27);
  static Color onPrimaryContainer = const Color(0xFF9DD090);
  static Color primaryFixed = const Color(0xFFBCF0AE);
  static Color primaryFixedDim = const Color(0xFFA1D494);
  static Color onPrimaryFixed = const Color(0xFF002201);
  static Color onPrimaryFixedVariant = const Color(0xFF23501E);

  static Color secondary = const Color(0xFF7A5649);
  static Color onSecondary = const Color(0xFFFFFFFF);
  static Color secondaryContainer = const Color(0xFFFDCDBC);
  static Color onSecondaryContainer = const Color(0xFF795548);
  static Color secondaryFixed = const Color(0xFFFFDBCF);
  static Color secondaryFixedDim = const Color(0xFFEBBCAC);
  static Color onSecondaryFixed = const Color(0xFF2E150B);
  static Color onSecondaryFixedVariant = const Color(0xFF603F33);

  static Color tertiary = const Color(0xFF4F3500);
  static Color onTertiary = const Color(0xFFFFFFFF);
  static Color tertiaryContainer = const Color(0xFF6C4A00);
  static Color onTertiaryContainer = const Color(0xFFFFB51E);
  static Color tertiaryFixed = const Color(0xFFFFDEAC);
  static Color tertiaryFixedDim = const Color(0xFFFFBA38);
  static Color onTertiaryFixed = const Color(0xFF281900);
  static Color onTertiaryFixedVariant = const Color(0xFF604100);

  static Color error = const Color(0xFFBA1A1A);
  static Color onError = const Color(0xFFFFFFFF);
  static Color errorContainer = const Color(0xFFFFDAD6);
  static Color onErrorContainer = const Color(0xFF93000A);

  static Color background = const Color(0xFFF8FAF5);
  static Color onBackground = const Color(0xFF191C1A);
  static Color surface = const Color(0xFFF8FAF5);
  static Color onSurface = const Color(0xFF191C1A);
  static Color surfaceVariant = const Color(0xFFE1E3DE);
  static Color onSurfaceVariant = const Color(0xFF42493E);
  static Color surfaceDim = const Color(0xFFD8DBD6);
  static Color surfaceBright = const Color(0xFFF8FAF5);
  static Color surfaceContainerLowest = const Color(0xFFFFFFFF);
  static Color surfaceContainerLow = const Color(0xFFF2F4EF);
  static Color surfaceContainer = const Color(0xFFECEFEA);
  static Color surfaceContainerHigh = const Color(0xFFE7E9E4);
  static Color surfaceContainerHighest = const Color(0xFFE1E3DE);

  static Color outline = const Color(0xFF72796E);
  static Color outlineVariant = const Color(0xFFC2C9BB);

  static Color inverseSurface = const Color(0xFF2E312E);
  static Color inverseOnSurface = const Color(0xFFEFF1EC);
  static Color inversePrimary = const Color(0xFFA1D494);

  // Dark theme colors (Premium forest obsidian theme)
  static const darkScaffoldBackground = Color(0xFF060907); // Very deep forest black
  static const darkSurface = Color(0xFF0F1511); // Rich obsidian emerald
  static const darkOnSurface = Color(0xFFECF3EE); // Minty off-white
  static const darkSurfaceContainerHighest = Color(0xFF1A231C); // Emerald card surface
  static const darkOnPrimary = Color(0xFF003910); // Deep forest text
  static const darkOnSecondary = Color(0xFF412519); // Muted brown text
  static const darkOnTertiary = Color(0xFF372A00); // Dark olive text
  static const darkError = Color(0xFFE57373); // Muted warm red
  static const darkOnError = Color(0xFF4A0002);
  static const darkOutline = Color(0xFF4E5E52); // Muted moss green outline
  static const darkPrimary = Color(0xFF65D58F); // Premium emerald accent green
  static const darkPrimaryContainer = Color(0xFF0C5120); // Deep rich container green
  static const darkOnPrimaryContainer = Color(0xFFB1F7BF); // High contrast mint green

  static void updateTheme(bool isDark) {
    if (isDark) {
      primary = darkPrimary;
      onPrimary = darkOnPrimary;
      primaryContainer = darkPrimaryContainer;
      onPrimaryContainer = darkOnPrimaryContainer;
      background = darkScaffoldBackground;
      surface = darkSurface;
      onSurface = darkOnSurface;
      surfaceVariant = darkSurfaceContainerHighest;
      onSurfaceVariant = darkOnSurface;
      surfaceDim = darkScaffoldBackground;
      surfaceBright = darkSurface;
      surfaceContainerLowest = darkSurface;
      surfaceContainerLow = darkScaffoldBackground;
      surfaceContainer = darkSurface;
      surfaceContainerHigh = darkSurfaceContainerHighest;
      surfaceContainerHighest = darkSurfaceContainerHighest;
      outline = darkOutline;
      outlineVariant = darkOutline;
      error = darkError;
      onError = darkOnError;
    } else {
      primary = const Color(0xFF154212);
      onPrimary = const Color(0xFFFFFFFF);
      primaryContainer = const Color(0xFF2D5A27);
      onPrimaryContainer = const Color(0xFF9DD090);
      background = const Color(0xFFF8FAF5);
      surface = const Color(0xFFF8FAF5);
      onSurface = const Color(0xFF191C1A);
      surfaceVariant = const Color(0xFFE1E3DE);
      onSurfaceVariant = const Color(0xFF42493E);
      surfaceDim = const Color(0xFFD8DBD6);
      surfaceBright = const Color(0xFFF8FAF5);
      surfaceContainerLowest = const Color(0xFFFFFFFF);
      surfaceContainerLow = const Color(0xFFF2F4EF);
      surfaceContainer = const Color(0xFFECEFEA);
      surfaceContainerHigh = const Color(0xFFE7E9E4);
      surfaceContainerHighest = const Color(0xFFE1E3DE);
      outline = const Color(0xFF72796E);
      outlineVariant = const Color(0xFFC2C9BB);
      error = const Color(0xFFBA1A1A);
      onError = const Color(0xFFFFFFFF);
    }
  }
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
      appBarTheme: AppBarTheme(
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
            return IconThemeData(
              color: AppColors.onPrimaryContainer,
            );
          }
          return IconThemeData(
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
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
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
      appBarTheme: AppBarTheme(
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
            return IconThemeData(
              color: AppColors.primaryFixed,
            );
          }
          return IconThemeData(
            color: AppColors.outlineVariant,
          );
        }),
      ),
    );
  }
}
