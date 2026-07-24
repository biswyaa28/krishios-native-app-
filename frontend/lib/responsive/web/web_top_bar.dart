import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';

class WebTopBar extends ConsumerWidget {
  final VoidCallback onToggleRightPanel;
  final bool isRightPanelOpen;

  const WebTopBar({
    super.key,
    required this.onToggleRightPanel,
    required this.isRightPanelOpen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final activeLang = ref.watch(languageProvider);

    final bgCanvas = isDark ? const Color(0xFF1B2E1A) : const Color(0xFFF6F4ED);
    final cardBg = isDark ? const Color(0xFF121D12) : Colors.white;
    final borderColor = isDark ? const Color(0x33F6F4ED) : const Color(0x1F1A2919);
    final textPrimary = isDark ? const Color(0xFFF6F4ED) : const Color(0xFF1A2919);
    final textSecondary = isDark ? const Color(0xFFA4B8A2) : const Color(0xFF4B5E4A);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: bgCanvas,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Universal Search Bar (Ctrl + K)
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 18, color: textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      TranslationService.translate('search_placeholder', activeLang),
                      style: TextStyle(fontSize: 13, color: textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: bgCanvas,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      'Ctrl + K',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Quick Theme Toggle Button
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: textPrimary,
              size: 20,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle();
            },
          ),
          const SizedBox(width: 8),

          // Language Indicator Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.language_rounded, size: 14, color: textSecondary),
                const SizedBox(width: 6),
                Text(
                  TranslationService.supportedLanguages[activeLang] ?? 'English',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // AI Edge Engine Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  TranslationService.translate('edge_ai_ready', activeLang),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Toggle Right Panel Action
          IconButton(
            icon: Icon(
              isRightPanelOpen ? Icons.view_sidebar : Icons.view_sidebar_outlined,
              color: isRightPanelOpen ? const Color(0xFF233B22) : textSecondary,
              size: 20,
            ),
            onPressed: onToggleRightPanel,
            tooltip: 'Toggle Agronomy Telemetry Panel',
          ),
        ],
      ),
    );
  }
}
