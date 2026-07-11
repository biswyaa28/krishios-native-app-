# KrishiOS Improvements — Design Spec

**Date:** 2026-07-08
**Goal:** Demo/pitch readiness
**Timeline:** 4 weeks

---

## Context

KrishiOS is a Flutter agriculture app for Indian farmers. Currently it has:
- 4 screens (Home, Crop Scan, Stats, Community)
- Real weather API (OpenMeteo) but everything else is hardcoded/mock
- No state management (setState only)
- No local persistence
- No backend/authentication

The goal is to make it demo/pitch ready by adding proper architecture, persistence, backend integration, and real data — while keeping the existing UI as the base.

---

## Scope

6 improvement areas across 3 phases:

1. **State Management** (Riverpod)
2. **Local Persistence** (Hive)
3. **Firebase Auth & Firestore**
4. **Live Community Feed**
5. **Enhanced Weather Dashboard**
6. **Real Analytics & Yield Tracking**

AI Crop Disease Detection is **out of scope** for this iteration.

---

## Architecture

### Folder Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── constants/
│   │   └── api_constants.dart
│   └── utils/
│       └── formatters.dart
├── features/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── weather/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── community/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── scan/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── stats/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── providers/
│   ├── models/
│   └── services/
└── firebase_options.dart
```

### Key Technology Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| State Management | Riverpod | Compile-safe, no BuildContext, better testability |
| Local DB | Hive | Fast NoSQL, type-safe, offline-first |
| Backend | Firebase | Fast setup, real-time Firestore, auth built-in |
| Architecture | Clean Architecture (lite) | Separation of concerns without over-engineering |

---

## Phase 1: Foundation (Week 1-2)

### 1A. Riverpod State Management

**What:** Replace all `setState()` calls with Riverpod providers.

**Providers to create:**

- `WeatherProvider` — fetches and caches weather, auto-refreshes every 30 min
- `CommunityProvider` — manages post feed, pagination, likes
- `StatsProvider` — manages analytics data, scan history
- `ScanHistoryProvider` — manages scan results
- `UserPrefsProvider` — manages user settings

**Migration approach:**
- Start with WeatherCard (already has API call)
- Then CommunityScreen (most complex state)
- Then StatsScreen and HomeScreen
- Finally, global state (theme, user prefs)

**Dependencies to add:**
```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
dev_dependencies:
  riverpod_generator: ^2.6.3
  build_runner: ^2.4.14
```

### 1B. Hive Local Persistence

**What:** Type-safe local storage for offline data.

**Hive Boxes:**

| Box | Purpose | Data |
|-----|---------|------|
| `ScanHistoryBox` | Past scan results | ScanResult objects |
| `UserPrefsBox` | Settings, theme | Key-value pairs |
| `WeatherCacheBox` | Last weather fetch | Weather + timestamp |
| `CommunityDraftsBox` | Offline posts | Draft post objects |

**Type adapters:** Generate with `build_runner` for all models.

**Dependencies to add:**
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
dev_dependencies:
  hive_generator: ^2.0.1
```

---

## Phase 2: Backend & Community (Week 2-3)

### 2A. Firebase Auth & Firestore

**What:** User authentication and real-time database.

**Firebase Services:**
- **Auth:** Google Sign-In + email/password
- **Firestore:** Real-time database for community data
- **Storage:** Image uploads for posts and scan photos
- **Cloud Functions:** Weather alerts, analytics processing

**Firestore Schema:**

```
users/{userId}
  - name: string
  - email: string
  - role: "farmer" | "expert"
  - avatarUrl: string
  - createdAt: timestamp

posts/{postId}
  - authorId: string → users
  - title: string
  - body: string
  - category: string
  - imageUrl: string (optional)
  - likesCount: int
  - commentsCount: int
  - createdAt: timestamp

comments/{commentId}
  - postId: string → posts
  - authorId: string → users
  - text: string
  - createdAt: timestamp
```

**Security Rules:**
- Posts: read public, write authenticated
- Comments: read public, write authenticated
- Users: read public, write own profile only

### 2B. Live Community Feed

**What:** Replace mock posts with real Firestore data.

**Features:**
- Real-time post feed using Firestore streams
- Create post with title, body, category, optional image
- Like/unlike with optimistic updates
- Comment on posts with real-time updates
- Expert badge for verified agronomists
- Search and filter by category

**UI Changes:**
- Add pull-to-refresh on community feed
- Show loading skeleton while fetching
- Image picker for post images
- User avatar from Firebase profile

---

## Phase 3: Weather & Analytics (Week 3-4)

### 3A. Enhanced Weather Dashboard

**What:** Extend weather from basic to farming-focused.

**New Features:**

| Feature | Source | Description |
|---------|--------|-------------|
| 7-Day Forecast | OpenMeteo | Daily high/low temps, rain probability |
| Farming Alerts | Cloud Function | Frost warning, heavy rain, heatwave |
| Historical Data | OpenMeteo | 30-day temperature/precipitation trends |
| Soil Conditions | OpenMeteo | Soil temperature at different depths |

**UI:**
- Expand weather card to show 5-day mini forecast
- Alert banner for active farming warnings
- Historical chart (reuse existing chart component)
- Soil moisture recommendation based on weather

**New API calls:**
```dart
// 7-day forecast
'&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max'

// Historical
'&past_days=30&daily=temperature_2m_max,temperature_2m_min,precipitation_sum'
```

### 3B. Real Analytics Dashboard

**What:** Replace mock stats with real data from scan history.

**Data Sources:**
- Local: Scan history from Hive
- Firebase: Aggregated stats from user's scans

**Metrics:**

| Metric | Description | Calculation |
|--------|-------------|-------------|
| Total Scans | Lifetime scan count | Count from Hive |
| Weekly Trend | Scans this week vs last | Date comparison |
| Health Score | Average crop health | Average of scan results |
| Field Health Over Time | Historical health chart | Daily/weekly averages |
| Yield Prediction | Estimated yield impact | Based on health trends |

**UI:**
- Update existing stats cards with real numbers
- Line chart for health trends (replace bar chart)
- Time range selector (week/month/quarter)
- Export button for PDF report generation

---

## Dependencies (All Phases)

```yaml
dependencies:
  # Phase 1
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Phase 2
  firebase_core: ^3.12.1
  firebase_auth: ^5.5.4
  cloud_firestore: ^5.6.9
  firebase_storage: ^12.4.7
  google_sign_in: ^6.2.2

  # Phase 3
  fl_chart: ^0.70.2
  share_plus: ^10.1.4
  path_provider: ^2.1.5

dev_dependencies:
  riverpod_generator: ^2.6.3
  hive_generator: ^2.0.1
  build_runner: ^2.4.14
  json_annotation: ^4.9.0
  json_serializable: ^6.8.0
```

---

## Testing Strategy

- **Unit tests:** Providers, repositories, services
- **Widget tests:** Key screens (Home, Community, Stats)
- **Integration tests:** Firebase flows (auth, CRUD)

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Firebase costs | Medium | Set budget alerts, use Firestore rules to limit reads |
| Hive migration | Low | Migrate incrementally, keep fallback to mock data |
| Riverpod learning curve | Low | Use existing patterns, keep providers simple |
| Offline sync conflicts | Medium | Last-write-wins for community, local-first for scans |

---

## Success Criteria

- [ ] All screens use Riverpod providers
- [ ] Data persists locally via Hive
- [ ] Firebase auth works (Google + email)
- [ ] Community feed shows real Firestore data
- [ ] Weather shows 7-day forecast + alerts
- [ ] Stats show real scan history data
- [ ] No hardcoded/mock data remaining
- [ ] App runs offline with cached data
