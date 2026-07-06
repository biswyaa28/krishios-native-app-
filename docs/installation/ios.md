# iOS Target Setup Guide

This guide details target configuration for building iOS applications.

---

## 1. Prerequisites
* A physical Apple macOS workstation.
* Xcode installed and licensed.

---

## 2. Booting the iOS Simulator

1. Launch Xcode.
2. Under the Xcode menu, select **Open Developer Tool** > **Simulator**.
3. A default virtual iOS simulator device will boot.

---

## 3. Provisioning Profiles & Code Signing

To compile the application to run on a physical iPhone or iPad, Xcode requires team profile signoffs:

1. Open `frontend/ios/Runner.xcworkspace` in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. In the left navigation sidebar, select the top-level **Runner** project node.
3. Open the **Signing & Capabilities** tab.
4. Under **Team**, select your Apple Developer account profile.
5. In **Bundle Identifier**, modify the suffix signature if you encounter identification conflicts.

---

## 4. Run Check

Verify connected simulators or device list:
```bash
flutter devices
```
Expected output:
* iOS simulator device listing.
