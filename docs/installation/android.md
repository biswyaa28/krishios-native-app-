# Android Target Setup Guide

This guide details target device configuration for Android builds.

---

## 1. SDK Configurations

Verify your SDK configurations match the project targets:
* **compileSdk:** 34+ (Flutter automatically queries the SDK version).
* **minSdk:** 21 (Supported by modern Android architectures).
* **targetSdk:** 34+

Ensure **Android SDK Command-line Tools** are installed in the Android Studio SDK Manager under **SDK Tools**.

---

## 2. Setting Up an Emulator

1. Open Android Studio.
2. Select **Virtual Device Manager** (Device Manager) from the welcome screen or settings.
3. Click **Create Device**.
4. Choose a device definition (e.g., Pixel 7) and click **Next**.
5. Select a system image: Android 14 (API 34) or higher (x86_64 recommended for Intel/AMD CPUs).
6. Click **Finish** to build the virtual device.
7. Launch the emulator by clicking the **Play** button in the Device Manager.

---

## 3. Physical Device Testing

1. On your Android device, open **Settings** > **About Phone**.
2. Tap **Build Number** 7 times to enable Developer Options.
3. Return to settings, search for **Developer Options**, and enable:
   - **Developer Options**
   - **USB Debugging**
4. Connect the phone to your developer workstation using a USB data cable.
5. Accept the RSA fingerprint authorization alert on the phone.

---

## 4. Run Check

Confirm the device is recognized by Flutter:
```bash
flutter devices
```

Expected output:
* Connected device listing showing your emulator or physical Android phone.
