import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import '../providers/weather_provider.dart';

class ForecastCard extends ConsumerWidget {
  const ForecastCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final forecastAsync = ref.watch(forecastProvider);

    return forecastAsync.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (forecasts) {
        if (forecasts.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('7-DAY FORECAST', style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1)),
              const SizedBox(height: 12),
              ...forecasts.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(DateFormat('EEE').format(f.date), style: AppTextStyles.labelSm),
                    ),
                    Icon(_weatherIcon(f.weatherCode), size: 20, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(f.weatherDescription, style: AppTextStyles.bodySm),
                    ),
                    Text('${f.maxTemp.round()}°', style: AppTextStyles.labelMd),
                    const SizedBox(width: 4),
                    Text('${f.minTemp.round()}°', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 48) return Icons.foggy;
    if (code <= 67) return Icons.water_drop;
    if (code <= 77) return Icons.ac_unit;
    return Icons.thunderstorm;
  }
}
