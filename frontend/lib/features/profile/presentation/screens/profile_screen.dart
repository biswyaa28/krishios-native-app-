import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/user_profile.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../scan/presentation/screens/scan_history_screen.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _uploading = false;

  Future<void> _updateName(UserProfile profile, String activeLang) async {
    final nameController = TextEditingController(text: profile.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(TranslationService.translate('update_name_title', activeLang)),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: TranslationService.translate('full_name', activeLang)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(TranslationService.translate('cancel', activeLang)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isEmpty) return;
              Navigator.pop(ctx);
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(profile.uid)
                    .update({'name': newName});
                await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name updated successfully.')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text(TranslationService.translate('save', activeLang)),
          ),
        ],
      ),
    );
  }

  Future<void> _changeAvatar(UserProfile profile) async {
    final picker = ImagePicker();
    try {
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;

      setState(() => _uploading = true);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('avatars')
          .child(profile.uid)
          .child('profile.jpg');

      await storageRef.putData(await file.readAsBytes());
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(profile.uid)
          .update({'avatarUrl': downloadUrl});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Avatar uploaded successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final isGuest = ref.watch(isGuestProvider);
    final activeLang = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.translate('profile_title', activeLang)),
        elevation: 0,
      ),
      body: isGuest
          ? _buildGuestView(activeLang)
          : profileAsync.when(
              data: (profile) {
                if (profile == null) return Center(child: Text(TranslationService.translate('profile_not_found', activeLang)));
                return _buildProfileContent(profile, activeLang);
              },
              loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(child: Text('Error loading profile: $err')),
            ),
    );
  }

  Widget _buildGuestView(String activeLang) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 96, color: Colors.grey),
            const SizedBox(height: 16),
            Text(TranslationService.translate('guest_mode', activeLang), style: AppTextStyles.headlineMd),
            const SizedBox(height: 8),
            Text(
              TranslationService.translate('guest_mode_desc', activeLang),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(isGuestProvider.notifier).state = false;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(TranslationService.translate('sign_in_register', activeLang)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProfile profile, String activeLang) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.secondaryContainer,
                child: _uploading
                    ? CircularProgressIndicator(color: AppColors.primary)
                    : profile.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profile.avatarUrl!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text(
                            profile.name.isNotEmpty ? profile.name[0] : '?',
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                          ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    onPressed: () => _changeAvatar(profile),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(profile.name, style: AppTextStyles.headlineMd),
                  IconButton(
                    icon: Icon(Icons.edit, size: 18, color: AppColors.primary),
                    onPressed: () => _updateName(profile, activeLang),
                  ),
                ],
              ),
              Text(profile.email, style: AppTextStyles.bodyMd.copyWith(color: Colors.grey)),
              Text('Role: ${profile.role.toUpperCase()}', style: AppTextStyles.bodySm),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(TranslationService.translate('features_settings', activeLang), style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.history, color: AppColors.primary),
                title: Text(TranslationService.translate('Scan History', activeLang)),
                subtitle: Text(TranslationService.translate('Scan', activeLang)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.settings_outlined, color: AppColors.primary),
                title: Text(TranslationService.translate('settings_title', activeLang)),
                subtitle: Text(TranslationService.translate('settings_desc', activeLang)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).signOut();
            },
            icon: const Icon(Icons.logout),
            label: Text(TranslationService.translate('log_out', activeLang)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ),
      ],
    );
  }
}
