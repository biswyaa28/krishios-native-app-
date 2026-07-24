# iOS Target - KrishiOS

## Firebase Setup

1. Download `GoogleService-Info.plist` from Firebase Console > Project Settings > iOS app
2. Place it at `ios/Runner/GoogleService-Info.plist`
3. The shared `Firebase.initializeApp()` call in `lib/main.dart` reads this automatically

## Building

```bash
cd frontend
flutter build ios
```

## Permissions (Info.plist)

- Camera: NSCameraUsageDescription
- Microphone: NSMicrophoneUsageDescription
- Location: NSLocationWhenInUseUsageDescription
- Photo Library: NSPhotoLibraryUsageDescription

## Signing

A personal Apple Developer account is configured for code signing.
Change team/bundle identifier in Xcode or `flutter build ios` flags for distribution.
