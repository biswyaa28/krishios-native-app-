import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/presentation/providers/navigation_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/features/profile/presentation/screens/profile_screen.dart';

class KrishiMobileHeader extends ConsumerWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool? showBackButton;

  const KrishiMobileHeader({
    super.key,
    this.title = 'KrishiOS',
    required this.subtitle,
    this.trailing,
    this.showBackButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLang = ref.watch(languageProvider);
    final topInset = MediaQuery.of(context).padding.top;
    final canPop = Navigator.canPop(context);
    final currentIndex = ref.watch(mainTabIndexProvider);
    final shouldShowBack = showBackButton ?? (canPop || currentIndex != 0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        kIsWeb ? 12 : (topInset + 8),
        12,
        12,
      ),
      child: Row(
        children: [
          // 1. Back Button or Hamburger Drawer Menu Icon
          if (shouldShowBack)
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 22),
              tooltip: 'Back',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  ref.read(mainTabIndexProvider.notifier).state = 0;
                }
              },
            )
          else
            IconButton(
              icon: Icon(Icons.menu_rounded, color: AppColors.primary, size: 26),
              tooltip: 'Open Menu',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          const SizedBox(width: 8),

          // 2. Official Brand Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/brand/app_icon.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),

          // 3. Title & Subtitle Stack
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineMd.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 4. Trailing Action Slot
          trailing ??
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          TranslationService.translate('edge_ai_ready', activeLang),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: Icon(Icons.account_circle_outlined, color: AppColors.primary, size: 26),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
