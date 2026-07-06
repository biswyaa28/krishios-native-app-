# iOS Compilation & App Store Distribution Guide

This document describes how to compile the iOS app package archive (`.ipa`) and prepare it for TestFlight or the App Store.

---

## 1. Local Archive Compilation

Open `ios/Runner.xcworkspace` in Xcode, or run the following command in your terminal:
```bash
cd frontend
flutter build ipa --release
```

The output build files are written to:
`build/ios/archive/Runner.xcarchive`

---

## 2. TestFlight upload

1. Open Xcode Organizer (Window > Organizer).
2. Select your compiled `.xcarchive` file and click **Distribute App**.
3. Choose **App Store Connect** > **Upload** to send the archive directly to Apple.
4. Once processed on App Store Connect, configure internal/external testers inside **TestFlight**.
