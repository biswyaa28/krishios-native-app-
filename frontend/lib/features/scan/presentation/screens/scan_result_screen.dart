import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/scan_result.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../../agronomy/widgets/agronomy_report_widget.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chat_screen.dart';

class ScanResultScreen extends ConsumerStatefulWidget {
  final ScanResult scan;

  const ScanResultScreen({super.key, required this.scan});

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends ConsumerState<ScanResultScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleAudioReadout(String textToSpeak, String langCode) async {
    if (_isPlaying) {
      await _tts.stop();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      await _tts.setLanguage(langCode == 'hi' ? 'hi-IN' : 'en-US');
      await _tts.setSpeechRate(0.45);
      if (mounted) setState(() => _isPlaying = true);
      await _tts.speak(textToSpeak);
    }
  }

  void _shareReport(BuildContext context) {
    final text = 'KrishiOS Diagnostic Report:\n'
        'Crop: ${widget.scan.cropName}\n'
        'Pathology: ${widget.scan.diagnosis}\n'
        'Health Score: ${(widget.scan.healthScore.isNaN || widget.scan.healthScore.isInfinite ? 0.0 : widget.scan.healthScore).toStringAsFixed(1)}%\n'
        'Recommended Action: ${widget.scan.treatment ?? "Monitor soil conditions."}';
    Share.share(text, subject: 'KrishiOS Leaf Diagnosis');
  }

  @override
  Widget build(BuildContext context) {
    final scan = widget.scan;
    final weatherAsync = ref.watch(weatherProvider);
    final weather = weatherAsync.valueOrNull;
    final activeLang = ref.watch(languageProvider);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = kIsWeb || width >= 900;

    final isHealthy = scan.diagnosis.toLowerCase().contains('healthy');
    final severity = isHealthy ? 'None' : (scan.healthScore < 40 ? 'High' : (scan.healthScore < 75 ? 'Medium' : 'Low'));
    final severityColor = isHealthy 
        ? AppColors.primary 
        : (severity == 'High' ? AppColors.error : (severity == 'Medium' ? Colors.orange : Colors.amber));

    final localizedCrop = TranslationService.translateCrop(scan.cropName, activeLang);
    final localizedDisease = TranslationService.translateDisease(scan.diagnosis, activeLang);
    final textToSpeak = 'Crop: $localizedCrop. Diagnosis: $localizedDisease. Recommended treatment: ${scan.treatment ?? "Monitor soil conditions."}';

    if (isDesktop) {
      return Scaffold(
        appBar: AppBar(
          title: Text(TranslationService.translate('diag_report', activeLang)),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.volume_off : Icons.volume_up),
              onPressed: () => _toggleAudioReadout(textToSpeak, activeLang),
              tooltip: 'Audio Readout',
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => _shareReport(context),
              tooltip: 'Share Report',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (Crop Image, Pathology Info, Gauges, CTA)
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (scan.imagePath != null && scan.imagePath!.isNotEmpty)
                            (scan.imagePath!.startsWith('http') || kIsWeb)
                                ? Image.network(
                                    scan.imagePath!,
                                    height: 260,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _buildFallbackImage(),
                                  )
                                : Image.file(
                                    File(scan.imagePath!),
                                    height: 260,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _buildFallbackImage(),
                                  )
                          else
                            _buildFallbackImage(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(localizedCrop, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: severityColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${TranslationService.translate('severity', activeLang)}: $severity',
                                        style: AppTextStyles.labelSm.copyWith(color: severityColor, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${TranslationService.translate('diagnosis', activeLang)}: $localizedDisease',
                                  style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  TranslationService.translate('scanned_just_now', activeLang),
                                  style: AppTextStyles.bodySm.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Health Score & AI Confidence Gauges Grid
                    _buildMetricsSection(scan),

                    const SizedBox(height: 16),

                    if (scan.confidence != null && scan.confidence! < 0.5)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          border: Border.all(color: Colors.orange.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange.shade800, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                TranslationService.translate('low_confidence', activeLang),
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Ask Kavya AI Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF233B22),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: Text(TranslationService.translate('ask_ai', activeLang), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Right Column (Agronomy Report & Paginated Tab Advisory)
              Expanded(
                flex: 7,
                child: AgronomyReportWidget(scan: scan, weather: weather),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile Vertical Scroll Layout
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationService.translate('diag_report', activeLang)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.volume_off : Icons.volume_up),
            onPressed: () => _toggleAudioReadout(textToSpeak, activeLang),
            tooltip: 'Audio Readout',
          ),
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
                  (scan.imagePath!.startsWith('http') || kIsWeb)
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
                          Text(localizedCrop, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: severityColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${TranslationService.translate('severity', activeLang)}: $severity',
                              style: AppTextStyles.labelSm.copyWith(color: severityColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${TranslationService.translate('diagnosis', activeLang)}: $localizedDisease',
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        TranslationService.translate('scanned_just_now', activeLang),
                        style: AppTextStyles.bodySm.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildMetricsSection(scan),
          const SizedBox(height: 16),

          // Low confidence warning
          if (scan.confidence != null && scan.confidence! < 0.5)
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade800, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      TranslationService.translate('low_confidence', activeLang),
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          AgronomyReportWidget(scan: scan, weather: weather),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.chat_bubble_outline),
        label: Text(TranslationService.translate('ask_ai', activeLang)),
      ),
    );
  }

  Widget _buildMetricsSection(ScanResult scan) {
    final healthVal = scan.healthScore.isNaN || scan.healthScore.isInfinite ? 0.0 : scan.healthScore;
    final confVal = (scan.confidence ?? 1.0) * 100;

    return Row(
      children: [
        Expanded(
          child: _buildGaugeCard(
            title: 'Health Score',
            percentage: healthVal,
            color: healthVal > 70 ? Colors.green : (healthVal > 35 ? Colors.orange : Colors.redAccent),
            icon: Icons.favorite,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildGaugeCard(
            title: 'AI Confidence',
            percentage: confVal,
            color: AppColors.primary,
            icon: Icons.check_circle,
          ),
        ),
      ],
    );
  }

  Widget _buildGaugeCard({
    required String title,
    required double percentage,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 56,
                width: 56,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 5,
                  backgroundColor: color.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Icon(icon, color: color, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11),
          ),
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
}
