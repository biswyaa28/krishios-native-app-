import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/services/hive_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final Box _prefsBox = HiveService.getUserPrefsBox();

  bool get _darkMode => _prefsBox.get('dark_mode', defaultValue: false);
  bool get _pushNotifications => _prefsBox.get('notifications', defaultValue: true);
  bool get _offlineSync => _prefsBox.get('offline_sync', defaultValue: true);
  String get _language => _prefsBox.get('language', defaultValue: 'English');

  void _togglePreference(String key, bool value) {
    setState(() {
      _prefsBox.put(key, value);
    });
  }

  void _changeLanguage(String? lang) {
    if (lang == null) return;
    setState(() {
      _prefsBox.put('language', lang);
    });
  }

  void _showPolicyDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(body),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Preferences
          Text('Preferences', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark user interface themes.'),
                  value: _darkMode,
                  activeColor: AppColors.primary,
                  onChanged: (val) => _togglePreference('dark_mode', val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Alert me of community post comments & news.'),
                  value: _pushNotifications,
                  activeColor: AppColors.primary,
                  onChanged: (val) => _togglePreference('notifications', val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Offline Database Caching'),
                  subtitle: const Text('Allow scanning crops offline.'),
                  value: _offlineSync,
                  activeColor: AppColors.primary,
                  onChanged: (val) => _togglePreference('offline_sync', val),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('App Language'),
                  trailing: DropdownButton<String>(
                    value: _language,
                    onChanged: _changeLanguage,
                    items: ['English', 'Hindi', 'Spanish']
                        .map((lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Legal & About
          Text('Legal & About', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPolicyDialog(
                    'Privacy Policy',
                    'KrishiOS respects your user privacy. Your scanned crop images and profile logs are saved inside Firebase Storage and Cloud Firestore securely under your authenticated ID scope. We do not sell or compile user data for third-party advertising networks.',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPolicyDialog(
                    'Terms of Service',
                    'By using KrishiOS mobile services, you agree to submit valid crop leaf photos to run AI disease classifications. The returned diagnosis models function as agronomy advisory parameters; we do not guarantee total harvest yields or assume liabilities for local crop treatment choices.',
                  ),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App Version'),
                  trailing: Text('1.0.0 (Production Build)', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Log Out
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ref.read(authServiceProvider).signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out of Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
