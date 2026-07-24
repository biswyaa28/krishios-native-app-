import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'firebase_options.dart';
import 'shared/services/hive_service.dart';
import 'shared/providers/auth_provider.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/scan/presentation/screens/crop_scan_screen.dart';
import 'features/stats/presentation/screens/stats_screen.dart';
import 'features/community/presentation/screens/community_screen.dart';
import 'features/auth/presentation/screens/platform_auth_screen.dart';
import 'features/auth/presentation/screens/language_selection_screen.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'shared/presentation/widgets/navigation_drawer.dart';
import 'shared/presentation/widgets/krishi_ai_fab.dart';
import 'shared/presentation/providers/navigation_provider.dart';
import 'responsive/responsive_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    FlutterError.reportError(FlutterErrorDetails(
      exception: e,
      stack: StackTrace.current,
      context: ErrorDescription('Firebase initialization'),
    ));
  }
  await HiveService.init();
  runApp(const ProviderScope(child: KrishiOSApp()));
}

class KrishiOSApp extends ConsumerWidget {
  const KrishiOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    AppColors.updateTheme(themeMode == ThemeMode.dark);
    return MaterialApp(
      title: 'KrishiOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const MainShell(),
    );
  }
}

final splashDelayProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(milliseconds: 1500));
});

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ensure the user sees the Splash screen for at least 1.5s on fresh launch
    final splashDelay = ref.watch(splashDelayProvider);
    if (splashDelay.isLoading) {
      return  Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/brand/app_icon.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'KrishiOS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
        ),
      );
    }

    final hasSelectedLang = ref.watch(hasSelectedLanguageProvider);
    final debugBypass = ref.watch(debugLanguageBypassProvider);
    final shouldShowLang = kDebugMode ? !debugBypass : !hasSelectedLang;

    if (shouldShowLang) {
      return const LanguageSelectionScreen();
    }

    final isGuest = ref.watch(isGuestProvider);
    if (isGuest) {
      return const ResponsiveShell(mobileShell: _MainShellContent());
    }

    final authState = ref.watch(authStateProvider);
    return authState.when(
      loading: () =>  Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/brand/app_icon.png',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'KrishiOS',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(color: AppColors.primary),
            ],
          ),
        ),
      ),
      error: (_, __) => const PlatformAuthScreen(),
      data: (user) {
        if (user == null) return const PlatformAuthScreen();
        return const ResponsiveShell(mobileShell: _MainShellContent());
      },
    );
  }
}

class _MainShellContent extends ConsumerWidget {
  const _MainShellContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLang = ref.watch(languageProvider);
    final currentIndex = ref.watch(mainTabIndexProvider);

    final List<Widget> screens = const [
      HomeScreen(),
      CropScanScreen(),
      StatsScreen(),
      CommunityScreen(),
    ];

    return Scaffold(
      drawer: const KrishiNavigationDrawer(),
      floatingActionButton: const KrishiAiFab(),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(mainTabIndexProvider.notifier).state = index;
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: TranslationService.translate('home_tab', activeLang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.shutter_speed),
            selectedIcon: const Icon(Icons.shutter_speed),
            label: TranslationService.translate('scan_tab', activeLang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.query_stats_outlined),
            selectedIcon: const Icon(Icons.query_stats),
            label: TranslationService.translate('stats_tab', activeLang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: const Icon(Icons.group),
            label: TranslationService.translate('community_tab', activeLang),
          ),
        ],
      ),
    );
  }
}
