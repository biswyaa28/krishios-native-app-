# KrishiOS Platform Stabilization And iOS Parity Design

## Goal

Stabilize the existing Flutter app on Android, add a full iOS target with the same Firebase-oriented app behavior as Android, and fix confirmed shared-code issues so both mobile platforms use the same core flows.

## Current Project Context

- The mobile app lives in `frontend/` and is a Flutter app with shared code in `frontend/lib`.
- Android native files exist in `frontend/android`.
- No iOS target currently exists in the repository.
- The app uses Firebase Core/Auth/Firestore/Storage, Hive, Riverpod, camera, geolocation, speech-to-text, TTS, and an AI scan pipeline with local ONNX and remote FastAPI paths.
- Recent project history shows active work around Android build fixes, web deployment, and API endpoint resolution.

## Scope

### In Scope

- Fix confirmed shared Flutter bugs that affect Android now and would affect iOS later.
- Keep Android as the behavioral reference implementation.
- Add `frontend/ios` as a normal Flutter iOS target.
- Mirror Android platform capabilities on iOS as closely as the platform allows.
- Route scan execution through shared AI engine infrastructure instead of per-screen network code.
- Improve persistence and reliability in task, scan, and related app flows where defects are confirmed.
- Add regression tests for fixed shared logic.
- Document any remaining environment-provided inputs required for iOS parity, such as Firebase credentials files.

### Out Of Scope

- Replacing Firebase, Hive, Riverpod, or the existing AI architecture.
- Broad visual redesigns.
- Major product expansion unrelated to platform parity and stability.
- Large speculative refactors that are not required by a confirmed bug or parity need.

## Success Criteria

- Android continues to build and retains current behavior.
- iOS target exists and is wired to the same shared Flutter app entry path.
- Firebase initialization and mobile permissions are set up on iOS in the same overall way Android is set up now.
- Camera/gallery scan flow uses the shared AI engine path.
- Confirmed state and persistence defects in shared code are fixed.
- Added tests cover the fixed shared behaviors.
- Remaining external setup requirements are clearly documented.

## Recommended Approach

Use phased parity hardening.

This starts by fixing shared bugs before iOS inherits them, then hardens Android-native configuration, then adds the iOS target, then adds regression coverage. This is safer than creating iOS first or doing a broad shared-core refactor because the existing Android app already defines the expected behavior.

## Architecture Boundaries

### Shared App Layer

- Keep `frontend/lib` as the single source of app behavior.
- Consolidate scan execution through `AIEngineManager` and its engine implementations.
- Fix async/provider usage issues where current code reads transient state incorrectly.
- Persist task data instead of recreating an empty task list on startup.
- Keep changes minimal and local to the existing service/provider/screen boundaries unless a confirmed defect requires a small interface adjustment.

### Android Layer

- Verify Android build files, manifest, and Firebase/plugin configuration against actual app needs.
- Fix only confirmed Android-native issues.
- Preserve Android behavior as the parity baseline.

### iOS Layer

- Add a standard Flutter iOS target under `frontend/ios`.
- Mirror Android feature wiring for Firebase, sign-in dependencies, camera, microphone, location, and photo library access.
- Reuse the same shared Flutter initialization path in `main.dart`.
- Keep iOS feature behavior aligned with Android rather than adding iOS-only gates.

## Implementation Phases

### Phase 1: Shared Bug Verification And Fixes

- Re-verify each earlier finding before changing code.
- Convert confirmed shared bugs into failing tests where practical.
- Replace direct scan networking in `crop_scan_screen.dart` with the shared AI routing path.
- Fix provider/async misuse around location and other transient state.
- Improve task persistence and other confirmed shared reliability issues.

### Phase 2: Android Hardening

- Reconcile Android Gradle/config assumptions with files actually present in the repo.
- Fix confirmed build or release configuration gaps.
- Verify Android-facing analysis and test passes after each batch.

### Phase 3: iOS Parity

- Create the Flutter iOS project files.
- Add iOS permissions and platform metadata for camera, microphone, location, and photos.
- Wire Firebase on iOS in the same structural way Android is wired now.
- Keep the app feature set aligned with Android rather than disabling flows on iOS.

### Phase 4: Regression Coverage And Verification

- Add tests around AI engine routing, task persistence, scan repository behavior, and any fixed provider/state bug.
- Run targeted verification commands for Flutter analysis and tests.
- Document any remaining environment-specific requirements.

## Testing Strategy

- Use test-first for confirmed shared-code bug fixes where the behavior is testable outside the UI shell.
- Prefer unit/provider/service tests for business logic and state behavior.
- Use targeted widget tests only where a regression is primarily UI-driven.
- Run focused test commands during each phase instead of waiting until the end.

## Risks And Constraints

- Some earlier findings may prove speculative and should be removed from the fix list rather than forced into code changes.
- iOS Firebase parity depends on having the iOS credentials file supplied in the same way Android depends on its Firebase credentials.
- Some mobile plugin behavior differs by platform even when the shared Dart path is the same; parity means same user-facing capability, not identical native internals.
- Existing local-network backend assumptions may need to be normalized so both Android and iOS use a coherent host resolution strategy.

## External Inputs Required

- iOS Firebase credentials file equivalent to the Android Firebase setup.
- Any iOS signing/team configuration required outside source-controlled app code.

## Deliverables

- Shared Flutter code fixes in `frontend/lib`.
- Android configuration fixes in `frontend/android` if confirmed.
- New iOS target in `frontend/ios`.
- Added automated tests.
- A short implementation report describing what was fixed and what still depends on external credentials or signing.

## Notes

- This design document is written from the current repository state.
- It is not committed yet because no commit was requested in this session.
