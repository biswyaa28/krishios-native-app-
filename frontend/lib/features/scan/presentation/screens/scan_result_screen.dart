import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/models/scan_result.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanResult scan;

  const ScanResultScreen({super.key, required this.scan});

  void _shareReport(BuildContext context) {
    final text = 'KrishiOS Diagnostic Report:\n'
        'Crop: ${scan.cropName}\n'
        'Pathology: ${scan.diagnosis}\n'
        'Health Score: ${(scan.healthScore.isNaN || scan.healthScore.isInfinite ? 0.0 : scan.healthScore).toStringAsFixed(1)}%\n'
        'Recommended Action: ${scan.treatment ?? "Monitor soil conditions."}';
    Share.share(text, subject: 'KrishiOS Leaf Diagnosis');
  }

  @override
  Widget build(BuildContext context) {
    final isHealthy = scan.diagnosis.toLowerCase().contains('healthy');
    final severity = isHealthy ? 'None' : (scan.healthScore < 40 ? 'High' : (scan.healthScore < 75 ? 'Medium' : 'Low'));
    final severityColor = isHealthy 
        ? AppColors.primary 
        : (severity == 'High' ? AppColors.error : (severity == 'Medium' ? Colors.orange : Colors.amber));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Diagnostic Report'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReport(context),
            tooltip: 'Share Report',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Crop Header Card
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (scan.imagePath != null && scan.imagePath!.isNotEmpty)
                  scan.imagePath!.startsWith('http')
                      ? Image.network(
                          scan.imagePath!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallbackImage(),
                        )
                      : Image.file(
                          File(scan.imagePath!),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallbackImage(),
                        )
                else
                  _buildFallbackImage(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(scan.cropName, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: severityColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Severity: $severity',
                              style: AppTextStyles.labelSm.copyWith(color: severityColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Diagnosis: ${scan.diagnosis}',
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scanned on ${Formatters.relativeTime(scan.scannedAt)}',
                        style: AppTextStyles.bodySm.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Low confidence warning
          if (scan.confidence != null && scan.confidence! < 0.5)
            Card(
              color: Colors.orange.withValues(alpha: 0.15),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Low confidence result. The AI model is uncertain — manual inspection recommended.',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Diagnostic Analytics Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Health Score',
                  value: '${(scan.healthScore.isNaN || scan.healthScore.isInfinite ? 0.0 : scan.healthScore).toStringAsFixed(1)}%',
                  icon: Icons.favorite,
                  iconColor: Colors.redAccent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  title: 'AI Confidence',
                  value: '${((scan.confidence ?? 1.0) * 100).toStringAsFixed(1)}%',
                  icon: Icons.check_circle,
                  iconColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Treatment Protocol
          Text('Treatment Protocol', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          _buildDetailCard(
            title: 'Recommended Direct Treatment',
            body: scan.treatment ?? 'Monitor crop leaf state and perform baseline watering.',
            icon: Icons.health_and_safety,
            iconColor: Colors.blueAccent,
          ),
          const SizedBox(height: 8),
          _buildDetailCard(
            title: 'Preventive Measures',
            body: isHealthy 
                ? 'Maintain steady nitrogen crop rotation intervals.'
                : 'Isolate crop beds from neighboring rows to mitigate fungal leaf spore transfers.',
            icon: Icons.shield,
            iconColor: Colors.orangeAccent,
          ),
          const SizedBox(height: 8),

          // Fertilizer & Bio options
          _buildDetailCard(
            title: 'Recommended Fertilizers & Pesticides',
            body: isHealthy
                ? 'Standard organic NPK compost (10-10-10) during active growth states.'
                : 'Apply copper-based fungicides or sulfur sprays at 10-day intervals. Avoid nitrogen-heavy fertilizers during outbreaks.',
            icon: Icons.science_outlined,
            iconColor: Colors.purpleAccent,
          ),
          const SizedBox(height: 16),

          // Regional insight placeholder — will be populated with real data in future
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 200,
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white54, size: 48),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String body,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelSm.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(body, style: AppTextStyles.bodySm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
