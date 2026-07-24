class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final double precipitationSum;
  final int precipitationProbability;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationSum,
    required this.precipitationProbability,
    required this.weatherCode,
  });

  String get weatherDescription {
    if (weatherCode == 0) return 'Clear';
    if (weatherCode <= 3) return 'Cloudy';
    if (weatherCode <= 48) return 'Fog';
    if (weatherCode <= 57) return 'Drizzle';
    if (weatherCode <= 67) return 'Rain';
    if (weatherCode <= 77) return 'Snow';
    if (weatherCode <= 82) return 'Showers';
    if (weatherCode <= 86) return 'Snow';
    return 'Storm';
  }
}
