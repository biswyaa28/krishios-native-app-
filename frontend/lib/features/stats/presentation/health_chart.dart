import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/models/scan_result.dart';

class HealthChart extends StatelessWidget {
  final List<ScanResult> scans;

  const HealthChart({super.key, required this.scans});

  @override
  Widget build(BuildContext context) {
    if (scans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              Text('No scan data yet', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final recentScans = scans.where((s) => s.scannedAt.isAfter(thirtyDaysAgo)).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plant Health Trends', style: AppTextStyles.labelMd),
          const SizedBox(height: 4),
          Text('30-day index based on scan data', style: AppTextStyles.bodySm),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: recentScans.isEmpty
                ? Center(child: Text('No recent scans', style: AppTextStyles.bodySm))
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateSpots(recentScans),
                          isCurved: true,
                          color: AppColors.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.primary.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots(List<ScanResult> scans) {
    if (scans.isEmpty) return [];
    final now = DateTime.now();
    return scans.map((scan) {
      final daysAgo = now.difference(scan.scannedAt).inDays.toDouble();
      return FlSpot(daysAgo, scan.healthScore);
    }).toList();
  }
}
