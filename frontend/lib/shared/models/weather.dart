import 'package:hive/hive.dart';

class Weather extends HiveObject {
  final double temperature;
  final int humidity;
  final double precipitation;
  final double windSpeed;
  final String windDirection;
  final int weatherCode;
  final String location;
  final DateTime fetchedAt;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
    this.location = 'Current Location',
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  String get weatherDescription {
    if (weatherCode == 0) return 'Clear sky';
    if (weatherCode <= 3) return 'Mainly clear';
    if (weatherCode <= 48) return 'Foggy';
    if (weatherCode <= 57) return 'Drizzle';
    if (weatherCode <= 67) return 'Rain';
    if (weatherCode <= 77) return 'Snow';
    if (weatherCode <= 82) return 'Rain showers';
    if (weatherCode <= 86) return 'Snow showers';
    return 'Thunderstorm';
  }
}

class WeatherAdapter extends TypeAdapter<Weather> {
  @override
  final int typeId = 0;

  @override
  Weather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weather(
      temperature: (fields[0] as num).toDouble(),
      humidity: (fields[1] as num).toInt(),
      precipitation: (fields[2] as num).toDouble(),
      windSpeed: (fields[3] as num).toDouble(),
      windDirection: fields[4] as String,
      weatherCode: (fields[5] as num).toInt(),
      location: fields[6] as String,
      fetchedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Weather obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.temperature)
      ..writeByte(1)
      ..write(obj.humidity)
      ..writeByte(2)
      ..write(obj.precipitation)
      ..writeByte(3)
      ..write(obj.windSpeed)
      ..writeByte(4)
      ..write(obj.windDirection)
      ..writeByte(5)
      ..write(obj.weatherCode)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.fetchedAt);
  }
}
