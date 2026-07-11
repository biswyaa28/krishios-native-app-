import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:krishios/shared/models/weather.dart';
import 'package:krishios/shared/models/weather_forecast.dart';
import '../../data/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

final locationNameProvider = StateProvider<String?>((ref) => null);

final positionProvider = FutureProvider<Position?>((ref) async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ref.read(locationNameProvider.notifier).state = 'Patna, Bihar (Fallback)';
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ref.read(locationNameProvider.notifier).state = 'Patna, Bihar (Fallback)';
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ref.read(locationNameProvider.notifier).state = 'Patna, Bihar (Fallback)';
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    
    // Reverse geocode to retrieve city/state names
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final pm = placemarks.first;
        final city = pm.locality ?? pm.subAdministrativeArea ?? '';
        final state = pm.administrativeArea ?? '';
        if (city.isNotEmpty) {
          ref.read(locationNameProvider.notifier).state = '$city, $state';
        } else {
          ref.read(locationNameProvider.notifier).state = state;
        }
      }
    } catch (_) {
      ref.read(locationNameProvider.notifier).state = 'My Farm';
    }
    return pos;
  } catch (_) {
    ref.read(locationNameProvider.notifier).state = 'Patna, Bihar (Fallback)';
    return null;
  }
});

final weatherProvider = FutureProvider<Weather?>((ref) async {
  final repo = ref.watch(weatherRepositoryProvider);
  final positionAsync = ref.watch(positionProvider);
  final position = positionAsync.value;

  if (position != null) {
    return repo.fetchCurrentConditions(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
  return repo.fetchCurrentConditions(); // default Patna fallback
});

final forecastProvider = FutureProvider<List<DailyForecast>>((ref) async {
  final repo = ref.watch(weatherRepositoryProvider);
  final positionAsync = ref.watch(positionProvider);
  final position = positionAsync.value;

  if (position != null) {
    return repo.fetchForecast(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
  return repo.fetchForecast(); // default Patna fallback
});
