import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../weather/presentation/widgets/weather_alerts.dart';
import '../../../weather/presentation/widgets/weather_card.dart';
import '../../../weather/presentation/widgets/forecast_card.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../widgets/recent_scans_section.dart';
import '../widgets/recommended_actions_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
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
                    const Icon(
                      Icons.agriculture,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'KrishiOS',
                      style: AppTextStyles.headlineMd.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.account_circle_outlined, color: AppColors.primary, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      tooltip: 'My Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const WeatherAlerts(),
        const SizedBox(height: 16),
        const WeatherCard(),
        const SizedBox(height: 16),
        const ForecastCard(),
        const SizedBox(height: 24),
        const RecentScansSection(),
        const SizedBox(height: 24),
        const RecommendedActionsSection(),
      ],
    );
  }
}
