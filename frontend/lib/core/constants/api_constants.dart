class ApiConstants {
  static const String openMeteoBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoHistoricalUrl = 'https://archive-api.open-meteo.com/v1/archive';
  static const String scanBaseUrl = 'http://localhost:8080';

  /// Returns the backend host for the current platform:
  /// - iOS simulator / macOS: localhost (same machine)
  /// - Android emulator: 10.0.2.2 (maps to host localhost)
  /// - Physical device: defaults to scanBaseUrl host;
  ///   override by setting [overrideHost] to your machine's LAN IP
  // ignore: unnecessary_nullable_for_final_variable_declarations
  static const String? overrideHost = '10.171.249.162';

  static const String fallbackLocationName = 'Patna, Bihar (Fallback)';
  static const double fallbackLatitude = 25.6;
  static const double fallbackLongitude = 85.1;
}
