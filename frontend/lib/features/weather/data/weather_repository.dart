import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krishios/core/constants/api_constants.dart';
import 'package:krishios/shared/models/weather.dart';
import 'package:krishios/shared/models/weather_forecast.dart';
import 'package:krishios/shared/services/hive_service.dart';

class WeatherRepository {
  final http.Client _client;

  WeatherRepository({http.Client? client}) : _client = client ?? http.Client();

  static String _windDirectionLabel(double degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) % 360 / 45).floor();
    return directions[index];
  }

  Future<Weather?> fetchCurrentConditions({
    double latitude = ApiConstants.fallbackLatitude,
    double longitude = ApiConstants.fallbackLongitude,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.openMeteoBaseUrl).replace(queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m,wind_direction_10m,weather_code',
        'timezone': 'auto',
      });

      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>;

      final weather = Weather(
        temperature: (current['temperature_2m'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        precipitation: (current['precipitation'] as num).toDouble(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
        windDirection: _windDirectionLabel((current['wind_direction_10m'] as num).toDouble()),
        weatherCode: (current['weather_code'] as num).toInt(),
      );

      final box = HiveService.getWeatherBox();
      await box.put('current', weather);

      return weather;
    } catch (_) {
      final box = HiveService.getWeatherBox();
      return box.get('current');
    }
  }

  Future<List<DailyForecast>> fetchForecast({
    double latitude = ApiConstants.fallbackLatitude,
    double longitude = ApiConstants.fallbackLongitude,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.openMeteoBaseUrl).replace(queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'daily': 'temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,weather_code',
        'timezone': 'auto',
        'forecast_days': '7',
      });

      final response = await _client.get(uri);
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final daily = data['daily'] as Map<String, dynamic>;
      final dates = daily['time'] as List;
      final maxTemps = daily['temperature_2m_max'] as List;
      final minTemps = daily['temperature_2m_min'] as List;
      final precip = daily['precipitation_sum'] as List;
      final precipProb = daily['precipitation_probability_max'] as List;
      final codes = daily['weather_code'] as List;

      return List.generate(dates.length, (i) => DailyForecast(
        date: DateTime.parse(dates[i]),
        maxTemp: (maxTemps[i] as num).toDouble(),
        minTemp: (minTemps[i] as num).toDouble(),
        precipitationSum: (precip[i] as num).toDouble(),
        precipitationProbability: (precipProb[i] as num).toInt(),
        weatherCode: (codes[i] as num).toInt(),
      ));
    } catch (_) {
      return [];
    }
  }

  void dispose() => _client.close();
}
