import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/utils/formatters.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../../scan/presentation/providers/scan_provider.dart';
import '../../../scan/presentation/screens/scan_result_screen.dart';
import '../../../scan/presentation/screens/scan_history_screen.dart';

class RecentScansSection extends ConsumerWidget {
  const RecentScansSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scans = ref.watch(scanHistoryProvider);

    if (scans.isEmpty) {
      return const SizedBox.shrink(); // Hide section if no scans exist
    }

    final recentScans = scans.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Scans', style: AppTextStyles.headlineMd),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
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
            children: [
              for (int i = 0; i < recentScans.length; i++) ...[
                _buildScanItem(context, recentScans[i]),
                if (i < recentScans.length - 1) _divider(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScanItem(BuildContext context, ScanResult scan) {
    final isHealthy = scan.diagnosis.toLowerCase().contains('healthy');
    final icon = isHealthy ? Icons.eco : Icons.pest_control;
    final iconBg = isHealthy ? AppColors.surfaceContainer : AppColors.errorContainer;
    final iconColor = isHealthy ? AppColors.primary : AppColors.error;
    final timestampText = Formatters.relativeTime(scan.scannedAt);

    return ScanItem(
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      title: '${scan.cropName} (${scan.fieldName})',
      subtitle: '${scan.diagnosis} • $timestampText',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanResultScreen(scan: scan),
          ),
        );
      },
    );
  }

  Widget _divider() =>
      const Divider(height: 1, color: AppColors.outlineVariant);
}

class ScanItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ScanItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
        bottom: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelMd),
                  Text(subtitle, style: AppTextStyles.bodySm),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
