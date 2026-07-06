# Android App Compilation & Release Guide

This document describes how to compile the KrishiOS Flutter app to generate distribution binaries (APKs/App Bundles).

---

## 1. Local Debug Compilation

To build a debug package:
```bash
cd frontend
flutter build apk --debug
```
The output file is written to:
`build/app/outputs/flutter-apk/app-debug.apk`

---

## 2. Production Release Compilation

### Key signing config
Before building a production release, make sure you configure your release keystore parameters inside `android/key.properties` (or set corresponding environment variables).

To compile a signed distribution package:
```bash
flutter build apk --release
```
The output file is written to:
`build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Recommended for Google Play Console upload)
To package as an `.aab` file:
```bash
flutter build appbundle --release
```
The output file is written to:
`build/app/outputs/bundle/release/app-release.aab`
