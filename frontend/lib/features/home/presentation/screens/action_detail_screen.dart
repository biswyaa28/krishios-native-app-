import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ActionDetailScreen extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String title;
  final String description;
  final String buttonText;
  final List<DetailSection> sections;

  const ActionDetailScreen({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headlineMd),
                const SizedBox(height: 8),
                Text(description, style: AppTextStyles.bodyMd),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            buttonText == 'Schedule Action'
                                ? 'Action scheduled successfully'
                                : 'Marked as reviewed',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      buttonText == 'Schedule Action'
                          ? Icons.schedule
                          : Icons.check_circle_outline,
                      size: 20,
                    ),
                    label: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: AppTextStyles.labelMd,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final section in sections) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(section.icon,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(section.title,
                          style: AppTextStyles.labelMd),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(section.body, style: AppTextStyles.bodySm),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class DetailSection {
  final IconData icon;
  final String title;
  final String body;

  const DetailSection({
    required this.icon,
    required this.title,
    required this.body,
  });
}
