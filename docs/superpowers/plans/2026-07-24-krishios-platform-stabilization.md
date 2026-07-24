# KrishiOS Platform Stabilization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Stabilize the shared Flutter mobile app, harden Android-native configuration, and add iOS parity that mirrors the current Android Firebase-based setup.

**Architecture:** Keep `frontend/lib` as the shared source of truth, fix confirmed bugs in services/providers/screens with minimal surface-area changes, and add a standard `frontend/ios` Flutter target that reuses the existing Flutter entrypoint and Firebase initialization path. Use targeted tests around shared logic first so Android and iOS both inherit corrected behavior.

**Tech Stack:** Flutter, Riverpod, Hive, Firebase Core/Auth/Firestore/Storage, camera, geolocator, speech_to_text, flutter_tts, Kotlin/Gradle, Xcode/iOS Flutter target

---

## File Structure And Responsibilities

- `frontend/lib/features/scan/presentation/screens/crop_scan_screen.dart`: UI for capture/gallery scan entrypoint; should delegate processing instead of owning networking.
- `frontend/lib/features/scan/presentation/providers/scan_provider.dart`: shared AI engine manager/provider bootstrap.
- `frontend/lib/shared/services/ai_engine_manager_mobile.dart`: routing between remote API and on-device ONNX.
- `frontend/lib/shared/services/remote_api_engine.dart`: shared remote scan API client.
- `frontend/lib/features/weather/presentation/providers/weather_provider.dart`: geolocation provider behavior.
- `frontend/lib/features/tasks/presentation/providers/task_provider.dart`: task persistence/state.
- `frontend/lib/shared/services/hive_service.dart`: local storage boxes and app persistence initialization.
- `frontend/lib/shared/services/kavya/*.dart`: voice/assistant logic to harden after shared bug fixes.
- `frontend/android/**`: Android-native config verification/fixes.
- `frontend/ios/**`: new iOS target to create and configure.
- `frontend/test/**`: regression coverage for confirmed shared bugs.

## Pre-verified Findings To Correct Before Implementation

- `frontend/android/app/google-services.json` already exists.
- `frontend/android/app/proguard-rules.pro` already exists.
- `frontend/lib/core/providers/theme_provider.dart` already persists theme mode.

These earlier findings were false positives and should not drive code changes.

### Task 1: Add Test Coverage For Shared Routing And Persistence

**Files:**
- Create: `frontend/test/scan/ai_engine_manager_test.dart`
- Create: `frontend/test/tasks/task_provider_test.dart`
- Modify: `frontend/pubspec.yaml`

- [ ] **Step 1: Write the failing AI engine routing test**

Create `frontend/test/scan/ai_engine_manager_test.dart` with tests that assert:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:krishios/shared/models/ai_engine_result.dart';

void main() {
  test('placeholder', () {
    expect(true, isFalse);
  });
}
```

- [ ] **Step 2: Write the failing task persistence test**

Create `frontend/test/tasks/task_provider_test.dart` with tests that assert task state survives notifier recreation.

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder', () {
    expect(true, isFalse);
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

Run: `flutter test frontend/test/scan/ai_engine_manager_test.dart frontend/test/tasks/task_provider_test.dart`
Expected: FAIL because the placeholder assertions fail.

- [ ] **Step 4: Add any minimal dev dependency needed for focused testing**

If a provider helper is required, add only the minimal test dependency already standard for Flutter/Riverpod tests.

- [ ] **Step 5: Re-run tests to verify they still fail for the intended reason**

Run: `flutter test frontend/test/scan/ai_engine_manager_test.dart frontend/test/tasks/task_provider_test.dart`
Expected: FAIL only on the intended assertions.

### Task 2: Fix Scan Flow To Use Shared AI Routing

**Files:**
- Modify: `frontend/lib/features/scan/presentation/screens/crop_scan_screen.dart`
- Modify: `frontend/lib/shared/services/ai_engine_manager_mobile.dart`
- Modify: `frontend/lib/shared/services/remote_api_engine.dart`
- Modify: `frontend/test/scan/ai_engine_manager_test.dart`

- [ ] **Step 1: Replace direct scan networking with shared engine calls**

Update `crop_scan_screen.dart` so `_processImage()` calls the engine manager from `scanProvider` instead of building `MultipartRequest` itself.

- [ ] **Step 2: Make backend host resolution live in the shared engine path**

Keep host resolution and `/predict` calls in `remote_api_engine.dart` and `ai_engine_manager_mobile.dart`, not in the screen.

- [ ] **Step 3: Implement the real AI engine manager tests**

Replace placeholder assertions with tests for:

```dart
// Expected behaviors:
// - auto mode prefers cloud when reachable
// - auto mode falls back to local when cloud fails
// - forceLocal never requires cloud reachability
// - forceCloud returns cloud failure when remote path fails
```

- [ ] **Step 4: Run the targeted test file**

Run: `flutter test frontend/test/scan/ai_engine_manager_test.dart`
Expected: PASS

- [ ] **Step 5: Run Flutter analysis on affected shared files**

Run: `flutter analyze`
Expected: no new diagnostics from the modified scan/engine files.

### Task 3: Fix Shared Async And Location Usage

**Files:**
- Modify: `frontend/lib/features/scan/presentation/screens/crop_scan_screen.dart`
- Modify: `frontend/lib/features/weather/presentation/providers/weather_provider.dart`
- Create: `frontend/test/weather/weather_provider_test.dart`

- [ ] **Step 1: Write the failing weather/location test**

Create a test that proves the app can derive fallback behavior without relying on a synchronously-read loading `FutureProvider` state.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test frontend/test/weather/weather_provider_test.dart`
Expected: FAIL against current behavior.

- [ ] **Step 3: Fix location read behavior in scan flow**

Ensure scan processing either awaits the location future correctly or uses a stable already-resolved value path.

- [ ] **Step 4: Keep fallback location name and fallback coordinates behavior intact**

Preserve current fallback UX while removing the incorrect provider read pattern.

- [ ] **Step 5: Re-run targeted test**

Run: `flutter test frontend/test/weather/weather_provider_test.dart`
Expected: PASS

### Task 4: Persist Task State Instead Of Resetting On Startup

**Files:**
- Modify: `frontend/lib/features/tasks/presentation/providers/task_provider.dart`
- Modify: `frontend/lib/shared/services/hive_service.dart`
- Create: `frontend/lib/features/tasks/data/task_storage.dart`
- Modify: `frontend/test/tasks/task_provider_test.dart`

- [ ] **Step 1: Write the real persistence test**

Replace the placeholder task test with a test that creates tasks, recreates the notifier/storage boundary, and expects the tasks to still exist.

- [ ] **Step 2: Run the test to verify it fails**

Run: `flutter test frontend/test/tasks/task_provider_test.dart`
Expected: FAIL because the current notifier always starts empty.

- [ ] **Step 3: Add minimal task storage support**

Create `task_storage.dart` to isolate task serialization and persistence, and update `HiveService` only as needed to support a task box.

- [ ] **Step 4: Update `TaskListNotifier` to load persisted tasks and save on mutation**

Do not redesign task state; add the minimal persistence layer under the existing provider API.

- [ ] **Step 5: Re-run targeted test**

Run: `flutter test frontend/test/tasks/task_provider_test.dart`
Expected: PASS

### Task 5: Harden Assistant And Voice Services Where Shared Bugs Are Confirmed

**Files:**
- Modify: `frontend/lib/shared/services/kavya/voice_service.dart`
- Modify: `frontend/lib/shared/services/kavya/speech_recognition_service.dart`
- Modify: `frontend/lib/shared/services/kavya/context_manager.dart`
- Create: `frontend/test/kavya/context_manager_test.dart`

- [ ] **Step 1: Write the failing context assembly test**

Create a test proving `ContextManager` builds stable scan/weather context from provider state without relying on transient values incorrectly.

- [ ] **Step 2: Run the test to verify it fails or is missing behavior**

Run: `flutter test frontend/test/kavya/context_manager_test.dart`
Expected: FAIL or require implementation changes.

- [ ] **Step 3: Update shared assistant context/voice handling minimally**

Keep behavior the same where possible; fix only confirmed issues in state transitions, callback flow, or provider reads.

- [ ] **Step 4: Update speech API usage if current package surface requires it**

Only change deprecated usage if it causes analyzer/test breakage or blocks parity.

- [ ] **Step 5: Re-run targeted Kavya tests**

Run: `flutter test frontend/test/kavya/context_manager_test.dart`
Expected: PASS

### Task 6: Verify And Fix Android Native Configuration

**Files:**
- Modify if needed: `frontend/android/app/build.gradle.kts`
- Modify if needed: `frontend/android/build.gradle.kts`
- Modify if needed: `frontend/android/settings.gradle.kts`
- Modify if needed: `frontend/android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Verify current Android assumptions against the actual repo**

Specifically verify Firebase credentials file presence, ProGuard file presence, SDK/plugin compatibility, and manifest permissions.

- [ ] **Step 2: Fix only confirmed Android-native issues**

Do not change already-correct Firebase/proguard/theme wiring.

- [ ] **Step 3: Run Android-capable Flutter analysis/build verification**

Run: `flutter analyze`
Expected: no new diagnostics from Android-related changes.

- [ ] **Step 4: If environment supports it, run a debug build check**

Run: `flutter build apk --debug`
Expected: successful debug build, or a clearly documented environment blocker.

### Task 7: Add iOS Target And Mirror Android Setup

**Files:**
- Create/Modify: `frontend/ios/**`
- Modify if needed: `frontend/pubspec.yaml`
- Modify if needed: `frontend/lib/firebase_options.dart`

- [ ] **Step 1: Generate the iOS target from the Flutter app root**

Run from `frontend/`: `flutter create --platforms=ios .`
Expected: `frontend/ios` is created without overwriting shared Dart code.

- [ ] **Step 2: Add iOS app metadata and permission descriptions**

Mirror Android capabilities in iOS config for camera, microphone, location, and photo library.

- [ ] **Step 3: Wire Firebase on iOS the same way Android is wired structurally**

Keep the existing shared `Firebase.initializeApp` path in `main.dart` and make the iOS target expect its own Firebase credentials file in the standard iOS location.

- [ ] **Step 4: Ensure plugin registration/build settings match current dependencies**

Validate the iOS target can host camera, geolocation, speech, TTS, secure storage, and Firebase plugins.

- [ ] **Step 5: Run a Flutter iOS configuration check**

Run: `flutter analyze`
Expected: no new shared-code diagnostics after the iOS target is added.

### Task 8: Replace Placeholder Tests And Run Regression Suite

**Files:**
- Modify: `frontend/test/widget_test.dart`
- Modify: all new test files created above

- [ ] **Step 1: Replace any placeholder assertions left from earlier tasks**

All newly-created tests must verify real behavior, not sentinel failures.

- [ ] **Step 2: Run the focused regression suite**

Run: `flutter test frontend/test/scan/ai_engine_manager_test.dart frontend/test/tasks/task_provider_test.dart frontend/test/weather/weather_provider_test.dart frontend/test/kavya/context_manager_test.dart`
Expected: PASS

- [ ] **Step 3: Run the default Flutter test suite**

Run: `flutter test`
Expected: PASS

- [ ] **Step 4: Run final analysis**

Run: `flutter analyze`
Expected: PASS or only pre-existing diagnostics documented separately.

### Task 9: Document Remaining External Requirements

**Files:**
- Modify: `README.md` or create `frontend/ios/README.md`

- [ ] **Step 1: Document iOS Firebase credential placement**

Add exact instructions for the iOS Firebase credentials file location.

- [ ] **Step 2: Document any signing/team requirements**

Keep documentation minimal and directly actionable.

- [ ] **Step 3: Verify documentation references the actual repo paths**

Run: `grep -n "GoogleService-Info.plist\|ios" README.md frontend/ios/README.md`
Expected: correct path references.

## Self-Review

- Spec coverage: shared bug fixes, Android hardening, iOS target creation, regression coverage, and external requirements are all covered.
- Placeholder scan: no `TBD`/`TODO` placeholders remain in the plan; temporary placeholder test files are explicitly replaced in later tasks.
- Type consistency: tasks consistently reference `AIEngineManager`, `TaskListNotifier`, `ContextManager`, and `frontend/ios`.
