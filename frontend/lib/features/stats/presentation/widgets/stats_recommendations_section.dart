import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StatsRecommendationsSection extends StatelessWidget {
  const StatsRecommendationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.outlineVariant, width: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: AppColors.tertiaryFixedDim, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Top Recommendations to Improve Yield',
                  style: AppTextStyles.labelMd,
                ),
              ],
            ),
          ),
          const InsightItem(
            icon: Icons.science,
            iconBg: AppColors.errorContainer,
            iconColor: AppColors.error,
            title: 'Increase Nitrogen in Sector B',
            description:
                'Recent scans indicate mild chlorosis. A targeted nitrogen application is recommended within 48 hours to prevent yield loss.',
            actionLabel: 'Schedule Task',
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const InsightItem(
            icon: Icons.water_drop,
            iconBg: AppColors.secondaryContainer,
            iconColor: AppColors.onSecondaryContainer,
            title: 'Optimize Irrigation Cycle',
            description:
                'Soil moisture levels in Zone 3 are dropping faster than expected. Consider adjusting irrigation duration.',
            actionLabel: null,
          ),
        ],
      ),
    );
  }
}

class InsightItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String description;
  final String? actionLabel;

  const InsightItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.description,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelMd, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(description, style: AppTextStyles.bodySm, maxLines: 3, overflow: TextOverflow.ellipsis),
                if (actionLabel != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      actionLabel!,
                      style: AppTextStyles.labelSm,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
