import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LifetimeScansCard extends StatelessWidget {
  final int lifetimeCount;
  final int weeklyCount;

  const LifetimeScansCard({
    super.key,
    required this.lifetimeCount,
    required this.weeklyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIFETIME SCANS',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('$lifetimeCount', style: AppTextStyles.headlineLgMobile),
                      const SizedBox(width: 4),
                      Text('Completed', style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                       Icon(Icons.trending_up,
                          size: 16, color: AppColors.primaryContainer),
                      const SizedBox(width: 4),
                      Text('+$weeklyCount this week', style: AppTextStyles.labelSm),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration:  BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child:  Icon(Icons.shutter_speed,
                color: AppColors.onPrimaryContainer, size: 20),
          ),
        ],
      ),
    );
  }
}
