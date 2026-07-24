import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/providers/auth_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/features/profile/presentation/screens/profile_screen.dart';
import 'package:krishios/features/scan/presentation/screens/chat_screen.dart';
import 'package:krishios/features/scan/presentation/screens/scan_history_screen.dart';
import 'package:krishios/features/settings/presentation/screens/settings_screen.dart';
import '../screens/secondary_detail_screen.dart';
import 'package:krishios/features/notifications/presentation/screens/notification_center_screen.dart';
import 'package:krishios/features/auth/presentation/screens/language_selection_screen.dart';

class KrishiNavigationDrawer extends ConsumerWidget {
  const KrishiNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLang = ref.watch(languageProvider);
    final userProfileAsync = ref.watch(userProfileProvider);
    final isGuest = ref.watch(isGuestProvider);

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration:  BoxDecoration(
              color: AppColors.primary,
            ),
            currentAccountPicture: isGuest
                ? const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  )
                : userProfileAsync.maybeWhen(
                    data: (profile) => CircleAvatar(
                      backgroundColor: Colors.white24,
                      backgroundImage: profile?.avatarUrl != null
                          ? NetworkImage(profile!.avatarUrl!)
                          : null,
                      child: profile?.avatarUrl == null
                          ? Text(
                              profile?.name.isNotEmpty == true ? profile!.name[0] : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    orElse: () => const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                  ),
            accountName: isGuest
                ? Text(
                    TranslationService.translate('guest_mode', activeLang),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : userProfileAsync.maybeWhen(
                    data: (profile) => Text(
                      profile?.name ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    orElse: () => const Text('Loading...'),
                  ),
            accountEmail: isGuest
                ? Text(TranslationService.translate('continue_guest', activeLang))
                : userProfileAsync.maybeWhen(
                    data: (profile) => Text(profile?.email ?? ''),
                    orElse: () => const Text(''),
                  ),
          ),
          // Scrollable list items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildSectionHeader('ACCOUNT'),
                _buildDrawerTile(
                  context,
                  icon: Icons.person_outline,
                  label: TranslationService.translate('profile_title', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.agriculture_outlined,
                  label: 'My Farms',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'my_farms'),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.history,
                  label: TranslationService.translate('Scan History', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                    );
                  },
                ),
                const Divider(),
                _buildSectionHeader('AI & AGRICULTURE'),
                _buildDrawerTile(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: TranslationService.translate('chat_title', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatScreen(
                          scanId: 'general',
                          cropName: 'General',
                          diagnosis: 'General Chat',
                        ),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.wb_sunny_outlined,
                  label: 'Detailed Weather',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'detailed_weather'),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.analytics_outlined,
                  label: 'Crop Analytics',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'crop_analytics'),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildSectionHeader('APP'),
                _buildDrawerTile(
                  context,
                  icon: Icons.language,
                  label: TranslationService.translate('app_language', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.notifications_none_outlined,
                  label: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationCenterScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.settings_outlined,
                  label: TranslationService.translate('settings_title', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
                const Divider(),
                _buildSectionHeader('HELP'),
                _buildDrawerTile(
                  context,
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'help_support'),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.menu_book_outlined,
                  label: 'User Guide',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'user_guide'),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  label: TranslationService.translate('privacy_policy', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'privacy_policy'),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.description_outlined,
                  label: TranslationService.translate('terms_service', activeLang),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'terms_conditions'),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.info_outline,
                  label: 'About KrishiOS',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecondaryDetailScreen(type: 'about'),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildSectionHeader('ACCOUNT'),
                _buildDrawerTile(
                  context,
                  icon: Icons.logout,
                  label: TranslationService.translate('log_out', activeLang),
                  textColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(authServiceProvider).performLogout(ref);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 12, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary.withValues(alpha: 0.7),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primaryContainer),
      title: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
