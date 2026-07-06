# Troubleshooting Guide

This guide details common compiler and execution errors encountered during KrishiOS configuration.

---

## 1. Windows Cross-Drive Path Crash

### Symptoms
Compilation crashes during Kotlin compilation for packages like `geocoding_android` or `package_info_plus` with:
`IllegalArgumentException: this and base files have different roots`

### Cause
The project workspace is checked out on a secondary Windows partition/drive (e.g. `O:\`), while Gradle or Pub dependency caches reside on the primary system drive (e.g. `C:\`). Kotlin's incremental path translation logic cannot calculate relative paths across different drives.

### Solution
Disabling incremental compilation bypasses path conversions. Ensure the following property is active in your `frontend/android/gradle.properties`:
```properties
kotlin.incremental=false
```

---

## 2. Android build SDK Conflict

### Symptoms
`Execution failed for task ':geocoding_android:checkDebugAarMetadata'.`
Requires compileSdk >=34.

### Solution
Older package dependencies resolved to geocoding wrappers targeting compileSdk 33. We upgraded dependencies to `geocoding: ^5.0.0` and `geolocator: ^14.0.3` which target compileSdk 34+. Update your `pubspec.yaml` and run `flutter pub get`.

---

## 3. CocoaPods Podfile.lock Out of Sync (macOS/iOS)

### Symptoms
CocoaPods build failure:
`Podfile.lock is out of sync with Manifest.lock`

### Solution
Purge local Pods state and fetch dependencies clean:
```bash
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod cache clean --all
pod install
```
