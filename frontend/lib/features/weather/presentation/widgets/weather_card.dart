import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/utils/formatters.dart';
import 'package:krishios/shared/models/weather.dart';
import 'package:krishios/core/providers/theme_provider.dart';
import '../providers/weather_provider.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final weatherAsync = ref.watch(weatherProvider);
    final locationName = ref.watch(locationNameProvider);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: weatherAsync.when(
        loading: () => const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => _buildError(ref),
        data: (weather) {
          if (weather == null) return _buildError(ref);
          return _buildWeatherContent(weather, locationName);
        },
      ),
    );
  }

  Widget _buildError(WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT CONDITIONS',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
            Icon(Icons.wb_cloudy_outlined, color: AppColors.tertiaryFixedDim, size: 24),
          ],
        ),
        const SizedBox(height: 16),
        Text('Unable to load weather data', style: AppTextStyles.bodySm),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => ref.invalidate(weatherProvider),
          child: Text(
            'Tap to retry',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherContent(Weather weather, String? locationName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT CONDITIONS',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
            Icon(Icons.wb_cloudy_outlined, color: AppColors.tertiaryFixedDim, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              Formatters.temperature(weather.temperature),
              style: AppTextStyles.headlineLgMobile,
            ),
            const SizedBox(width: 8),
            Text(locationName ?? weather.location, style: AppTextStyles.bodySm),
          ],
        ),
        Divider(height: 24, color: AppColors.outlineVariant),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _weatherStat(Icons.water_drop_outlined, '${weather.humidity}% Humidity'),
            _weatherStat(Icons.water, '${weather.precipitation.round()}% Rain'),
            _weatherStat(Icons.air, '${weather.windSpeed.round()} km/h ${weather.windDirection}'),
          ],
        ),
      ],
    );
  }

  Widget _weatherStat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelSm),
      ],
    );
  }
}
