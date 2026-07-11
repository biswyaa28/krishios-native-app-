import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import '../providers/weather_provider.dart';

class WeatherAlerts extends ConsumerWidget {
  const WeatherAlerts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (weather) {
        if (weather == null) return const SizedBox.shrink();

        final alerts = <String>[];
        if (weather.temperature < 5) alerts.add('Frost Warning: Temperature below 5°C');
        if (weather.temperature > 40) alerts.add('Heatwave Alert: Temperature above 40°C');
        if (weather.precipitation > 20) alerts.add('Heavy Rain: ${weather.precipitation.round()}mm expected');
        if (weather.windSpeed > 50) alerts.add('Strong Wind: ${weather.windSpeed.round()} km/h');

        if (alerts.isEmpty) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Text('FARMING ALERTS', style: AppTextStyles.labelSm.copyWith(color: AppColors.error, letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 8),
              ...alerts.map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(alert, style: AppTextStyles.bodySm),
              )),
            ],
          ),
        );
      },
    );
  }
}
