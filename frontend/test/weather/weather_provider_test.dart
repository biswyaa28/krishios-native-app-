import 'package:flutter_riverpod/flutter_riverpod.dart' hide ProviderScope;
import 'package:flutter_test/flutter_test.dart';
import 'package:krishios/features/weather/presentation/providers/weather_provider.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  test('position provider resolves to null when location services are unavailable (no sync snapshot)', () async {
    final container = ProviderContainer(
      overrides: [
        positionProvider.overrideWith((ref) async => null),
      ],
    );

    addTearDown(() => container.dispose());

    final pos = await container.read(positionProvider.future);
    expect(pos, isNull);
  });

  test('position provider resolves position when location is available', () async {
    final container = ProviderContainer(
      overrides: [
        positionProvider.overrideWith((ref) async {
          return Position(
            latitude: 12.34,
            longitude: 56.78,
            timestamp: DateTime.now(),
            accuracy: 10,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        }),
      ],
    );

    addTearDown(() => container.dispose());

    final pos = await container.read(positionProvider.future);
    expect(pos, isNotNull);
    expect(pos!.latitude, closeTo(12.34, 0.001));
    expect(pos.longitude, closeTo(56.78, 0.001));
  });
}
