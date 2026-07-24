import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../../scan/presentation/providers/scan_provider.dart';
import '../../../scan/presentation/screens/scan_result_screen.dart';
import '../../../scan/presentation/screens/scan_history_screen.dart';
import '../../../scan/presentation/screens/chat_screen.dart';
import '../../../../core/providers/theme_provider.dart';

class RecentScansSection extends ConsumerWidget {
  const RecentScansSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final scans = ref.watch(scanHistoryProvider);

    if (scans.isEmpty) {
      return const SizedBox.shrink();
    }

    final recentScans = scans.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Diagnostics',
              style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary),
            ),
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
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentScans.length,
            itemBuilder: (context, index) {
              final scan = recentScans[index];
              return _buildHorizontalScanCard(context, ref, scan);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalScanCard(BuildContext context, WidgetRef ref, ScanResult scan) {
    final hasDisease = !scan.diagnosis.toLowerCase().contains('healthy');
    final severity = scan.healthScore > 80
        ? 'Low'
        : scan.healthScore > 50
            ? 'Moderate'
            : 'High';
    final severityColor = severity == 'Low'
        ? Colors.green
        : severity == 'Moderate'
            ? Colors.orange
            : Colors.red;

    final dateText = DateFormat('MMM dd, yyyy').format(scan.scannedAt);
    final confidenceText = scan.confidence != null
        ? '${(scan.confidence! * 100).toStringAsFixed(0)}%'
        : 'N/A';

    return Container(
      width: 295,
      margin: const EdgeInsets.only(right: 16, bottom: 8, top: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Crop Name & Health score)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    scan.cropName,
                    style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Health: ${scan.healthScore.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Diagnosis
            Text(
              scan.diagnosis,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelMd.copyWith(color: hasDisease ? Colors.redAccent : AppColors.onSurface),
            ),
            const SizedBox(height: 4),
            // Secondary details (Confidence, Date, Severity)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Conf: $confidenceText',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    dateText,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: severityColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Sev: $severity',
                      style: TextStyle(fontSize: 11, color: severityColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Quick action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.visibility_outlined,
                  tooltip: 'View Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ScanResultScreen(scan: scan)),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  tooltip: 'Ask Kavya',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          scanId: scan.id,
                          cropName: scan.cropName,
                          diagnosis: scan.diagnosis,
                        ),
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  tooltip: 'Share',
                  onPressed: () {
                    Share.share(
                      'Crop: ${scan.cropName}\nDiagnosis: ${scan.diagnosis}\nHealth Score: ${scan.healthScore.toStringAsFixed(0)}%\nReport generated by KrishiOS Kavya.',
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.calendar_today_outlined,
                  tooltip: 'Schedule Follow-up',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Follow-up scheduled for ${scan.cropName}.')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, size: 16, color: AppColors.primary),
          onPressed: onPressed,
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
