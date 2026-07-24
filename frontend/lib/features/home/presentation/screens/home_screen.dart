import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import 'package:krishios/features/scan/presentation/screens/crop_scan_screen.dart';
import 'package:krishios/features/weather/presentation/providers/weather_provider.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/presentation/widgets/krishi_mobile_header.dart';
import 'package:krishios/shared/services/translation_service.dart';
import 'package:krishios/features/community/presentation/screens/community_screen.dart';
import 'package:krishios/features/scan/presentation/screens/chat_screen.dart';
import 'package:krishios/features/tasks/presentation/providers/task_provider.dart';
import 'package:krishios/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:krishios/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:krishios/features/tasks/domain/models/task_model.dart';
import '../widgets/recent_scans_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider); // Rebuild layout dynamically on theme toggle
    final activeLang = ref.watch(languageProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    final weatherAsync = ref.watch(weatherProvider);
    final weather = weatherAsync.value;
    final locationName = ref.watch(locationNameProvider) ?? 'Patna, Bihar';

    final tasks = ref.watch(taskListProvider);
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).toList();

    // Time Formatting
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM dd').format(now);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        0,
        0,
        0,
        kIsWeb ? 16 : (80 + bottomInset),
      ),
      children: [
        // Unified Header with Hamburger Menu & Logo
        KrishiMobileHeader(
          subtitle: TranslationService.translate('sub_header', activeLang),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Live Dynamic Weather Widget Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.white70, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              locationName,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          dateStr,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weather?.temperature.toStringAsFixed(0) ?? "28"}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              weather?.weatherDescription ?? 'Partly Cloudy',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
                            ),
                          ],
                        ),
                        Icon(
                          weather?.weatherDescription.toLowerCase().contains('rain') ?? false
                              ? Icons.water_drop_rounded
                              : Icons.wb_sunny_rounded,
                          color: Colors.amber,
                          size: 56,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWeatherStat(
                          Icons.water_drop_outlined,
                          '${weather?.humidity.toStringAsFixed(0) ?? "65"}%',
                          TranslationService.translate('humidity', activeLang),
                        ),
                        _buildWeatherStat(
                          Icons.air_outlined,
                          '${weather?.windSpeed.toStringAsFixed(1) ?? "12.4"} km/h',
                          TranslationService.translate('wind', activeLang),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Primary Action: Crop Scan Banner
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CropScanScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.qr_code_scanner_rounded, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TranslationService.translate('crop_diagnosis_title', activeLang),
                              style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              TranslationService.translate('crop_diagnosis_desc', activeLang),
                              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Smart Quick Actions Bar (Compact Icons)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  TranslationService.translate('quick_actions', activeLang),
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCompactActionChip(
                      context,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Kavya AI',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChatScreen(
                              scanId: 'general',
                              cropName: 'General Query',
                              diagnosis: 'General Assistance',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildCompactActionChip(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: TranslationService.translate('calendar', activeLang),
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CalendarScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildCompactActionChip(
                      context,
                      icon: Icons.task_alt_rounded,
                      label: TranslationService.translate('tasks', activeLang),
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TaskListScreen()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildCompactActionChip(
                      context,
                      icon: Icons.forum_outlined,
                      label: TranslationService.translate('community_tab', activeLang),
                      color: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CommunityScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Scans Activity Section
              const RecentScansSection(),
              const SizedBox(height: 24),

              // Daily Task Advisory Checklist Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TranslationService.translate('tasks', activeLang),
                            style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TaskListScreen()),
                              );
                            },
                            child: Text(TranslationService.translate('view_all', activeLang)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completed ${completedTasks.length} of ${tasks.length} field operations',
                        style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: tasks.isNotEmpty ? (completedTasks.length / tasks.length) : 0,
                        backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildCompactActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
