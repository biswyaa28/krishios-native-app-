import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../../scan/presentation/providers/scan_provider.dart';
import '../health_chart.dart';
import '../widgets/lifetime_scans_card.dart';
import '../widgets/yield_efficiency_card.dart';
import '../widgets/stats_recommendations_section.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final scans = ref.watch(scanHistoryProvider);
    final avgHealth = ref.watch(averageHealthProvider);
    final weeklyCount = ref.watch(weeklyScanCountProvider);
    final lifetimeCount = scans.length;

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 80 + bottomInset),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    const Icon(Icons.agriculture, color: AppColors.primary, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'KrishiOS',
                      style: AppTextStyles.headlineMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.download, color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Yield & Analytics', style: AppTextStyles.headlineLgMobile),
        const SizedBox(height: 4),
        Text(
          'Overview of farm health and performance metrics.',
          style: AppTextStyles.bodySm,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: LifetimeScansCard(
                lifetimeCount: lifetimeCount,
                weeklyCount: weeklyCount,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: YieldEfficiencyCard(
                healthScore: avgHealth,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        HealthChart(scans: scans.cast<ScanResult>()),
        const SizedBox(height: 16),
        const StatsRecommendationsSection(),
      ],
    );
  }
}
