# Windows Developer Setup Guide

This guide describes how to configure a developer environment on Windows 11/10 to build and run KrishiOS.

---

## 1. Prerequisites

### Git
1. Download Git from [git-scm.com](https://git-scm.com/download/win).
2. Install with default settings, ensuring **Git from the command line and also from 3rd-party software** is selected.

### Flutter SDK
1. Download the latest stable Flutter SDK from [flutter.dev](https://docs.flutter.dev/get-started/install/windows/desktop).
2. Extract the zip folder to a clean directory (e.g., `C:\develop\flutter`).
3. Add `C:\develop\flutter\bin` to your User `PATH` environment variables.

### Java Development Kit (JDK) 17
1. Download Microsoft Build of OpenJDK 17 or Oracle JDK 17.
2. Install Java.
3. Configure `JAVA_HOME` environment variable pointing to the JDK root folder (e.g., `C:\Program Files\Microsoft\jdk-17.x.x`).
4. Append `%JAVA_HOME%\bin` to your system `PATH`.

---

## 2. Android Tools Configuration

### Android Studio & SDK
1. Download and install Android Studio from [developer.android.com](https://developer.android.com).
2. Run Android Studio and open the **SDK Manager** (Settings > Appearance & Behavior > System Settings > Android SDK).
3. Under **SDK Platforms**, install Android 14 (API 34) or higher.
4. Under **SDK Tools**, check and install:
   - Android SDK Build-Tools
   - Android SDK Command-line Tools (latest)
   - Android Emulator
- Click **Apply** to install.

### NDK (Side by Side)
* If your model training or native libraries compile scripts require NDK, check **NDK (Side by side)** under SDK Tools and click install.

### Accept Android Licenses
Open PowerShell or Command Prompt and execute:
```cmd
flutter doctor --android-licenses
```
Press `y` to accept all licenses.

---

## 3. IDE Setup (VS Code)

1. Install **VS Code** from [code.visualstudio.com](https://code.visualstudio.com).
2. Open extensions (Ctrl+Shift+X) and install:
   - **Flutter** (by Dart Code)
   - **Dart** (by Dart Code)

---

## 4. Verification

Verify your environment configuration using:
```bash
flutter doctor -v
```

Expected output:
* Flutter (Channel stable, status: [√])
* Android toolchain (status: [√])
* Chrome / Edge (status: [√])

---

## 5. Running the Project

1. Open a terminal inside the repository.
2. Navigate to `frontend/`.
3. Fetch packages:
   ```bash
   flutter pub get
   ```
4. Start an Android emulator or connect a physical device.
5. Run the application:
   ```bash
   flutter run
   ```
