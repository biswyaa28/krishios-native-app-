import 'package:firebase_core/firebase_core.dart';
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
import 'features/auth/presentation/screens/auth_screen.dart';

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
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, color: AppColors.primary, size: 72),
              SizedBox(height: 16),
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

    final isGuest = ref.watch(isGuestProvider);
    if (isGuest) {
      return const _MainShellContent();
    }

    final authState = ref.watch(authStateProvider);
    return authState.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, color: AppColors.primary, size: 72),
              SizedBox(height: 16),
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
      error: (_, __) => const AuthScreen(),
      data: (user) {
        if (user == null) return const AuthScreen();
        return const _MainShellContent();
      },
    );
  }
}

class _MainShellContent extends StatefulWidget {
  const _MainShellContent();

  @override
  State<_MainShellContent> createState() => _MainShellContentState();
}

class _MainShellContentState extends State<_MainShellContent> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CropScanScreen(),
    StatsScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shutter_speed),
            selectedIcon: Icon(Icons.shutter_speed),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.query_stats_outlined),
            selectedIcon: Icon(Icons.query_stats),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
