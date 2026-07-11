import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'gauge_painter.dart';

class YieldEfficiencyCard extends StatelessWidget {
  final double healthScore;

  const YieldEfficiencyCard({super.key, required this.healthScore});

  @override
  Widget build(BuildContext context) {
    final percentage = (healthScore * 100).round();
    final label = percentage >= 80 ? 'Optimal' : percentage >= 60 ? 'Good' : percentage > 0 ? 'Fair' : 'N/A';

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
                  'YIELD EFFICIENCY',
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
                      Text('$percentage%', style: AppTextStyles.headlineLgMobile),
                      const SizedBox(width: 4),
                      Text(label, style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  healthScore > 0 ? 'Average health score across all scans.' : 'No scans recorded yet.',
                  style: AppTextStyles.labelSm,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(48, 48),
                  painter: GaugePainter(progress: healthScore),
                ),
                const Icon(Icons.eco, color: AppColors.primary, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
