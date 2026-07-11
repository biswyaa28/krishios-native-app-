# KrishiOS Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make KrishiOS demo/pitch ready with proper architecture, persistence, backend, and real data.

**Architecture:** Clean Architecture (lite) with feature-based folder structure. Riverpod for state management, Hive for local persistence, Firebase for backend.

**Tech Stack:** Flutter, Dart, Riverpod, Hive, Firebase (Auth, Firestore, Storage, Cloud Functions), fl_chart, OpenMeteo API

---

## Phase 1: Foundation (Week 1-2)

### Task 1: Project Restructure & Dependencies

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/theme/app_theme.dart` (move existing)
- Create: `lib/core/constants/api_constants.dart`
- Create: `lib/core/utils/formatters.dart`
- Create: `lib/shared/models/` (directory)
- Create: `lib/shared/services/` (directory)
- Create: `lib/shared/providers/` (directory)
- Create: `lib/features/home/` (directory tree)
- Create: `lib/features/weather/` (directory tree)
- Create: `lib/features/community/` (directory tree)
- Create: `lib/features/scan/` (directory tree)
- Create: `lib/features/stats/` (directory tree)

- [ ] **Step 1: Add all dependencies to pubspec.yaml**

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  firebase_core: ^3.12.1
  firebase_auth: ^5.5.4
  cloud_firestore: ^5.6.9
  firebase_storage: ^12.4.7
  google_sign_in: ^6.2.2
  fl_chart: ^0.70.2
  share_plus: ^10.1.4
  path_provider: ^2.1.5
  json_annotation: ^4.9.0

dev_dependencies:
  riverpod_generator: ^2.6.3
  hive_generator: ^2.0.1
  build_runner: ^2.4.14
  json_serializable: ^6.8.0
```

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`
Expected: Dependencies resolved successfully

- [ ] **Step 3: Create core directory structure**

```bash
mkdir -p lib/core/theme lib/core/constants lib/core/utils
mkdir -p lib/shared/models lib/shared/services lib/shared/providers
mkdir -p lib/features/home/data lib/features/home/domain lib/features/home/presentation
mkdir -p lib/features/weather/data lib/features/weather/domain lib/features/weather/presentation
mkdir -p lib/features/community/data lib/features/community/domain lib/features/community/presentation
mkdir -p lib/features/scan/data lib/features/scan/domain lib/features/scan/presentation
mkdir -p lib/features/stats/data lib/features/stats/domain lib/features/stats/presentation
```

- [ ] **Step 4: Move app_theme.dart to core/theme/**

Move `lib/theme/app_theme.dart` to `lib/core/theme/app_theme.dart`

- [ ] **Step 5: Create api_constants.dart**

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String openMeteoBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String openMeteoHistoricalUrl = 'https://archive-api.open-meteo.com/v1/archive';
}
```

- [ ] **Step 6: Create formatters.dart**

```dart
// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  static String temperature(double temp) => '${temp.round()}°C';
  static String humidity(int humidity) => '$humidity%';
  static String windSpeed(double speed) => '${speed.round()} km/h';
  static String date(DateTime date) => DateFormat('MMM d, y').format(date);
  static String time(DateTime date) => DateFormat('h:mm a').format(date);
  static String dateTime(DateTime date) => DateFormat('MMM d, y • h:mm a').format(date);
  static String relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return Formatters.date(date);
  }
}
```

- [ ] **Step 7: Update all imports in existing files**

Update imports in `lib/main.dart`, `lib/screens/home_screen.dart`, etc. to use new paths.

- [ ] **Step 8: Commit**

```bash
git add -A
git commit -m "refactor: restructure project and add all dependencies"
```

---

### Task 2: Shared Data Models

**Files:**
- Create: `lib/shared/models/weather.dart`
- Create: `lib/shared/models/chat_message.dart`
- Create: `lib/shared/models/community_post.dart`
- Create: `lib/shared/models/scan_result.dart`
- Create: `lib/shared/models/user_profile.dart`
- Create: `lib/shared/models/weather_forecast.dart`

- [ ] **Step 1: Create weather.dart with Hive adapter**

```dart
// lib/shared/models/weather.dart
import 'package:hive/hive.dart';

part 'weather.g.dart';

@HiveType(typeId: 0)
class Weather extends HiveObject {
  @HiveField(0)
  final double temperature;

  @HiveField(1)
  final int humidity;

  @HiveField(2)
  final double precipitation;

  @HiveField(3)
  final double windSpeed;

  @HiveField(4)
  final String windDirection;

  @HiveField(5)
  final int weatherCode;

  @HiveField(6)
  final String location;

  @HiveField(7)
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
```

- [ ] **Step 2: Create scan_result.dart**

```dart
// lib/shared/models/scan_result.dart
import 'package:hive/hive.dart';

part 'scan_result.g.dart';

@HiveType(typeId: 1)
class ScanResult extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cropName;

  @HiveField(2)
  final String fieldName;

  @HiveField(3)
  final String diagnosis;

  @HiveField(4)
  final double healthScore;

  @HiveField(5)
  final DateTime scannedAt;

  @HiveField(6)
  final String? imagePath;

  ScanResult({
    required this.id,
    required this.cropName,
    required this.fieldName,
    required this.diagnosis,
    required this.healthScore,
    required this.scannedAt,
    this.imagePath,
  });
}
```

- [ ] **Step 3: Create community_post.dart**

```dart
// lib/shared/models/community_post.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String authorRole;
  final String title;
  final String body;
  final String category;
  final String? imageUrl;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isExpert;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.authorRole,
    required this.title,
    required this.body,
    required this.category,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
    this.isExpert = false,
  });

  factory CommunityPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommunityPost(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      authorAvatar: data['authorAvatar'],
      authorRole: data['authorRole'] ?? 'Farmer',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      category: data['category'] ?? 'General',
      imageUrl: data['imageUrl'],
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isExpert: data['isExpert'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'authorRole': authorRole,
      'title': title,
      'body': body,
      'category': category,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': FieldValue.serverTimestamp(),
      'isExpert': isExpert,
    };
  }
}
```

- [ ] **Step 4: Create chat_message.dart**

```dart
// lib/shared/models/chat_message.dart
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
```

- [ ] **Step 5: Create user_profile.dart**

```dart
// lib/shared/models/user_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'farmer',
      avatarUrl: data['avatarUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
```

- [ ] **Step 6: Create weather_forecast.dart**

```dart
// lib/shared/models/weather_forecast.dart
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
```

- [ ] **Step 7: Run build_runner to generate Hive adapters**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Generated .g.dart files for Hive models

- [ ] **Step 8: Commit**

```bash
git add -A
git commit -m "feat: add shared data models with Hive and Firestore support"
```

---

### Task 3: Hive Initialization & Boxes

**Files:**
- Create: `lib/shared/services/hive_service.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Create HiveService**

```dart
// lib/shared/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/weather.dart';
import '../models/scan_result.dart';

class HiveService {
  static const String weatherBox = 'weather_cache';
  static const String scanHistoryBox = 'scan_history';
  static const String userPrefsBox = 'user_prefs';
  static const String draftsBox = 'community_drafts';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WeatherAdapter());
    Hive.registerAdapter(ScanResultAdapter());

    await Hive.openBox<Weather>(weatherBox);
    await Hive.openBox<ScanResult>(scanHistoryBox);
    await Hive.openBox(userPrefsBox);
    await Hive.openBox(draftsBox);
  }

  static Box<Weather> getWeatherBox() => Hive.box<Weather>(weatherBox);
  static Box<ScanResult> getScanHistoryBox() => Hive.box<ScanResult>(scanHistoryBox);
  static Box getUserPrefsBox() => Hive.box(userPrefsBox);
  static Box getDraftsBox() => Hive.box(draftsBox);
}
```

- [ ] **Step 2: Update main.dart to initialize Hive**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/services/hive_service.dart';
import 'package:krishios/screens/home_screen.dart';
import 'package:krishios/screens/crop_scan_screen.dart';
import 'package:krishios/screens/stats_screen.dart';
import 'package:krishios/screens/community_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const ProviderScope(child: KrishiOSApp()));
}
```

- [ ] **Step 3: Run app to verify Hive initializes**

Run: `flutter run -d macos`
Expected: App launches without errors, Hive box files created

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: initialize Hive with weather and scan history boxes"
```

---

### Task 4: Weather Provider with Riverpod

**Files:**
- Create: `lib/features/weather/data/weather_repository.dart`
- Create: `lib/features/weather/domain/weather_provider.dart`
- Create: `lib/features/weather/presentation/weather_card.dart`

- [ ] **Step 1: Create WeatherRepository**

```dart
// lib/features/weather/data/weather_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:krishios/core/constants/api_constants.dart';
import 'package:krishios/shared/models/weather.dart';
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
    double latitude = 25.6,
    double longitude = 85.1,
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

      // Cache to Hive
      final box = HiveService.getWeatherBox();
      await box.put('current', weather);

      return weather;
    } catch (_) {
      // Return cached data on error
      final box = HiveService.getWeatherBox();
      return box.get('current');
    }
  }

  void dispose() => _client.close();
}
```

- [ ] **Step 2: Create WeatherProvider**

```dart
// lib/features/weather/domain/weather_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/models/weather.dart';
import '../data/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});

final weatherProvider = FutureProvider<Weather?>((ref) async {
  final repo = ref.watch(weatherRepositoryProvider);
  return repo.fetchCurrentConditions();
});

final locationNameProvider = StateProvider<String?>((ref) => null);
```

- [ ] **Step 3: Create WeatherCard widget**

```dart
// lib/features/weather/presentation/weather_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/utils/formatters.dart';
import '../domain/weather_provider.dart';

class WeatherCard extends ConsumerWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            const Icon(Icons.wb_cloudy_outlined, color: AppColors.tertiaryFixedDim, size: 24),
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

  Widget _buildWeatherContent(weather, String? locationName) {
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
            const Icon(Icons.wb_cloudy_outlined, color: AppColors.tertiaryFixedDim, size: 24),
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
        const Divider(height: 24, color: AppColors.outlineVariant),
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
```

- [ ] **Step 4: Update HomeScreen to use WeatherCard**

Replace the `_WeatherCard()` widget in `lib/screens/home_screen.dart` with `const WeatherCard()`.

- [ ] **Step 5: Run app to verify weather loads**

Run: `flutter run -d macos`
Expected: Weather card shows real data from OpenMeteo

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: add Riverpod weather provider with Hive caching"
```

---

### Task 5: Community Provider with Riverpod

**Files:**
- Create: `lib/features/community/data/community_repository.dart`
- Create: `lib/features/community/domain/community_provider.dart`

- [ ] **Step 1: Create CommunityRepository**

```dart
// lib/features/community/data/community_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:krishios/shared/models/community_post.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<CommunityPost>> getPosts({String? category, int limit = 20}) {
    Query query = _firestore.collection('posts').orderBy('createdAt', descending: true);
    if (category != null && category != 'Trending') {
      query = query.where('category', isEqualTo: category);
    }
    return query.limit(limit).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => CommunityPost.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createPost(CommunityPost post) async {
    await _firestore.collection('posts').add(post.toFirestore());
  }

  Future<void> toggleLike(String postId, bool isLiked) async {
    await _firestore.collection('posts').doc(postId).update({
      'likesCount': FieldValue.increment(isLiked ? -1 : 1),
    });
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  Future<void> addComment(String postId, String text, String authorId, String authorName) async {
    await _firestore.collection('posts').doc(postId).collection('comments').add({
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('posts').doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }
}
```

- [ ] **Step 2: Create CommunityProvider**

```dart
// lib/features/community/domain/community_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/shared/models/community_post.dart';
import '../data/community_repository.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'Trending');

final postsProvider = StreamProvider<List<CommunityPost>>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return repo.getPosts(category: category);
});

final likedPostsProvider = StateProvider<Set<String>>((ref) => {});
```

- [ ] **Step 3: Update CommunityScreen to use providers**

Refactor `lib/screens/community_screen.dart` to use `ConsumerWidget` and `ref.watch()` for posts.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: add Riverpod community provider with Firestore streams"
```

---

### Task 6: Home Screen Refactor

**Files:**
- Modify: `lib/screens/home_screen.dart`

- [ ] **Step 1: Refactor HomeScreen to use providers**

Replace all mock data and setState calls with Riverpod providers.

- [ ] **Step 2: Remove mock data lists**

Delete `_mockMessagesWheat`, `_mockMessagesCorn`, `_mockMessagesSoy`.

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "refactor: HomeScreen uses Riverpod providers, remove mock data"
```

---

## Phase 2: Backend & Community (Week 2-3)

### Task 7: Firebase Setup

**Files:**
- Modify: `lib/main.dart`
- Create: `lib/firebase_options.dart`
- Modify: `android/app/build.gradle`
- Modify: `ios/Runner/Info.plist`

- [ ] **Step 1: Install Firebase CLI and configure**

Run: `flutterfire configure`

- [ ] **Step 2: Update main.dart with Firebase init**

```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();
  runApp(const ProviderScope(child: KrishiOSApp()));
}
```

- [ ] **Step 3: Run app to verify Firebase initializes**

Run: `flutter run -d macos`
Expected: No Firebase errors in console

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: initialize Firebase with FlutterFire config"
```

---

### Task 8: Firebase Auth

**Files:**
- Create: `lib/shared/services/auth_service.dart`
- Create: `lib/shared/providers/auth_provider.dart`
- Create: `lib/screens/auth_screen.dart`

- [ ] **Step 1: Create AuthService**

```dart
// lib/shared/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _google.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _createUserProfile(userCredential.user!);
    return userCredential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUpWithEmail(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.updateDisplayName(name);
    await _createUserProfile(userCredential.user!, name: name);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  Future<void> _createUserProfile(User user, {String? name}) async {
    final doc = _firestore.collection('users').doc(user.uid);
    final existing = await doc.get();
    if (!existing.exists) {
      await doc.set({
        'name': name ?? user.displayName ?? 'User',
        'email': user.email,
        'role': 'farmer',
        'avatarUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
```

- [ ] **Step 2: Create AuthProvider**

```dart
// lib/shared/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
```

- [ ] **Step 3: Create AuthScreen**

```dart
// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.agriculture, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text('KrishiOS', style: AppTextStyles.headlineLgMobile.copyWith(color: AppColors.primary)),
              const SizedBox(height: 32),
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: AppColors.onPrimary)
                      : Text(_isLogin ? 'Sign In' : 'Sign Up'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'Create account' : 'Already have an account?'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final auth = ref.read(authServiceProvider);
      if (_isLogin) {
        await auth.signInWithEmail(_emailController.text, _passwordController.text);
      } else {
        await auth.signUpWithEmail(_emailController.text, _passwordController.text, _nameController.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
```

- [ ] **Step 4: Update main.dart to gate on auth**

```dart
// In main.dart, update KrishiOSApp or MainShell to check auth state
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const AuthScreen(),
      data: (user) {
        if (user == null) return const AuthScreen();
        return const _MainShellContent();
      },
    );
  }
}
```

- [ ] **Step 5: Test auth flow**

Run: `flutter run -d macos`
Expected: Auth screen shows, can sign up/in, Google sign-in works

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: add Firebase auth with email and Google sign-in"
```

---

### Task 9: Firestore Security Rules

**Files:**
- Create: `firestore.rules`

- [ ] **Step 1: Write Firestore rules**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
      allow delete: if request.auth != null && resource.data.authorId == request.auth.uid;

      match /comments/{commentId} {
        allow read: if true;
        allow create: if request.auth != null;
        allow delete: if request.auth != null && resource.data.authorId == request.auth.uid;
      }
    }
  }
}
```

- [ ] **Step 2: Deploy rules**

Run: `firebase deploy --only firestore:rules`

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "feat: add Firestore security rules"
```

---

### Task 10: Live Community Feed

**Files:**
- Modify: `lib/screens/community_screen.dart`
- Create: `lib/features/community/presentation/post_card.dart`
- Create: `lib/features/community/presentation/comments_sheet.dart`

- [ ] **Step 1: Create PostCard widget**

```dart
// lib/features/community/presentation/post_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/utils/formatters.dart';
import 'package:krishios/shared/models/community_post.dart';
import 'package:krishios/shared/providers/auth_provider.dart';
import '../domain/community_provider.dart';

class PostCard extends ConsumerWidget {
  final CommunityPost post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPosts = ref.watch(likedPostsProvider);
    final isLiked = likedPosts.contains(post.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.secondaryContainer,
                  child: post.authorAvatar != null
                      ? ClipOval(child: Image.network(post.authorAvatar!, width: 40, height: 40))
                      : Text(post.authorName[0], style: AppTextStyles.labelMd),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: AppTextStyles.labelMd),
                      Text('${post.authorRole} • ${Formatters.relativeTime(post.createdAt)}', style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
                if (post.isExpert)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Expert', style: AppTextStyles.labelSm.copyWith(color: AppColors.onTertiaryContainer)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.title, style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 4),
            Text(post.body, style: AppTextStyles.bodyMd, maxLines: 3, overflow: TextOverflow.ellipsis),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.imageUrl!, height: 192, width: double.infinity, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () => ref.read(communityRepositoryProvider).toggleLike(post.id, isLiked),
                  child: Row(
                    children: [
                      Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_outlined, size: 20, color: isLiked ? AppColors.primary : AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}', style: AppTextStyles.labelSm),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('${post.commentsCount}', style: AppTextStyles.labelSm),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Refactor CommunityScreen to use providers**

Replace all mock data with `ref.watch(postsProvider)`.

- [ ] **Step 3: Test real-time updates**

Run: `flutter run -d macos`
Create a post in Firestore console, verify it appears in app.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: live community feed with Firestore real-time updates"
```

---

## Phase 3: Weather & Analytics (Week 3-4)

### Task 11: 7-Day Forecast

**Files:**
- Modify: `lib/features/weather/data/weather_repository.dart`
- Create: `lib/shared/models/weather_forecast.dart`
- Create: `lib/features/weather/presentation/forecast_card.dart`

- [ ] **Step 1: Add forecast fetching to WeatherRepository**

```dart
// Add to WeatherRepository
Future<List<DailyForecast>> fetchForecast({
  double latitude = 25.6,
  double longitude = 85.1,
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
```

- [ ] **Step 2: Create forecastProvider**

```dart
// Add to weather_provider.dart
final forecastProvider = FutureProvider<List<DailyForecast>>((ref) async {
  final repo = ref.watch(weatherRepositoryProvider);
  return repo.fetchForecast();
});
```

- [ ] **Step 3: Create ForecastCard widget**

```dart
// lib/features/weather/presentation/forecast_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/core/utils/formatters.dart';
import 'package:intl/intl.dart';
import '../domain/weather_provider.dart';

class ForecastCard extends ConsumerWidget {
  const ForecastCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
```

- [ ] **Step 4: Add ForecastCard to HomeScreen**

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat: add 7-day weather forecast to home screen"
```

---

### Task 12: Scan History Provider

**Files:**
- Create: `lib/features/scan/data/scan_repository.dart`
- Create: `lib/features/scan/domain/scan_provider.dart`

- [ ] **Step 1: Create ScanRepository**

```dart
// lib/features/scan/data/scan_repository.dart
import 'package:krishios/shared/models/scan_result.dart';
import 'package:krishios/shared/services/hive_service.dart';

class ScanRepository {
  List<ScanResult> getScanHistory() {
    final box = HiveService.getScanHistoryBox();
    final scans = box.values.toList();
    scans.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return scans;
  }

  Future<void> addScan(ScanResult scan) async {
    final box = HiveService.getScanHistoryBox();
    await box.put(scan.id, scan);
  }

  Future<void> deleteScan(String id) async {
    final box = HiveService.getScanHistoryBox();
    await box.delete(id);
  }

  double getAverageHealthScore() {
    final scans = getScanHistory();
    if (scans.isEmpty) return 0;
    return scans.map((s) => s.healthScore).reduce((a, b) => a + b) / scans.length;
  }

  int getWeeklyScanCount() {
    final scans = getScanHistory();
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return scans.where((s) => s.scannedAt.isAfter(weekAgo)).length;
  }
}
```

- [ ] **Step 2: Create ScanProvider**

```dart
// lib/features/scan/domain/scan_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/scan_repository.dart';

final scanRepositoryProvider = Provider<ScanRepository>((ref) => ScanRepository());

final scanHistoryProvider = Provider<List<ScanResult>>((ref) {
  return ref.watch(scanRepositoryProvider).getScanHistory();
});

final averageHealthProvider = Provider<double>((ref) {
  return ref.watch(scanRepositoryProvider).getAverageHealthScore();
});

final weeklyScanCountProvider = Provider<int>((ref) {
  return ref.watch(scanRepositoryProvider).getWeeklyScanCount();
});
```

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "feat: add scan history provider with Hive persistence"
```

---

### Task 13: Real Analytics Dashboard

**Files:**
- Modify: `lib/screens/stats_screen.dart`
- Create: `lib/features/stats/presentation/health_chart.dart`

- [ ] **Step 1: Refactor StatsScreen to use providers**

Replace mock numbers with:
- `ref.watch(scanHistoryProvider)` for scan list
- `ref.watch(averageHealthProvider)` for health score
- `ref.watch(weeklyScanCountProvider)` for weekly count

- [ ] **Step 2: Create HealthChart widget**

```dart
// lib/features/stats/presentation/health_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/models/scan_result.dart';

class HealthChart extends StatelessWidget {
  final List<ScanResult> scans;

  const HealthChart({super.key, required this.scans});

  @override
  Widget build(BuildContext context) {
    if (scans.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text('No scan data yet', style: AppTextStyles.bodySm),
        ),
      );
    }

    // Group by day for last 30 days
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final recentScans = scans.where((s) => s.scannedAt.isAfter(thirtyDaysAgo)).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plant Health Trends', style: AppTextStyles.labelMd),
          const SizedBox(height: 4),
          Text('30-day index based on scan data', style: AppTextStyles.bodySm),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots(recentScans),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateSpots(List<ScanResult> scans) {
    if (scans.isEmpty) return [];
    final now = DateTime.now();
    return scans.map((scan) {
      final daysAgo = now.difference(scan.scannedAt).inDays.toDouble();
      return FlSpot(daysAgo, scan.healthScore);
    }).toList();
  }
}
```

- [ ] **Step 3: Update StatsScreen layout**

Use real data in the cards and add HealthChart.

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: real analytics dashboard with scan history data"
```

---

### Task 14: Weather Alerts

**Files:**
- Create: `lib/features/weather/presentation/weather_alerts.dart`

- [ ] **Step 1: Create WeatherAlerts widget**

```dart
// lib/features/weather/presentation/weather_alerts.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import '../domain/weather_provider.dart';

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
```

- [ ] **Step 2: Add WeatherAlerts to HomeScreen above WeatherCard**

- [ ] **Step 3: Commit**

```bash
git add -A
git commit -m "feat: add farming weather alerts (frost, rain, heatwave)"
```

---

### Task 15: Final Polish & Cleanup

**Files:**
- Modify: Various screens

- [ ] **Step 1: Remove all remaining mock data**

Grep for any remaining hardcoded/mock data and remove.

- [ ] **Step 2: Add pull-to-refresh to CommunityScreen**

- [ ] **Step 3: Add loading skeletons to all async screens**

- [ ] **Step 4: Run full test suite**

Run: `flutter test`

- [ ] **Step 5: Run flutter analyze**

Run: `flutter analyze`
Fix any issues.

- [ ] **Step 6: Final commit**

```bash
git add -A
git commit -m "chore: final polish, remove all mock data, add loading states"
```

---

## Success Criteria

- [ ] All screens use Riverpod providers (Task 4, 5, 6, 13)
- [ ] Data persists locally via Hive (Task 2, 3, 12)
- [ ] Firebase auth works (Task 8)
- [ ] Community feed shows real Firestore data (Task 9, 10)
- [ ] Weather shows 7-day forecast + alerts (Task 11, 14)
- [ ] Stats show real scan history data (Task 12, 13)
- [ ] No hardcoded/mock data remaining (Task 15)
- [ ] App runs offline with cached data (Hive)
