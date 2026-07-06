# Linux Developer Setup Guide

This guide describes how to configure a developer environment on Linux (Ubuntu/Debian) to build and run KrishiOS.

---

## 1. Prerequisites

### System Libraries
Install Git, build utilities, and system dependency packages:
```bash
sudo apt update
sudo apt install -y git curl cmake dbus pkg-config liblzma-dev libglu1-mesa-dev
```

### Flutter SDK
1. Download the stable Linux SDK zip from [flutter.dev](https://docs.flutter.dev/get-started/install/linux/desktop).
2. Extract to a directory:
   ```bash
   mkdir -p ~/develop
   tar -xf flutter_linux_*.tar.xz -C ~/develop
   ```
3. Add the binary path to your shell configuration (e.g., `~/.bashrc` or `~/.zshrc`):
   ```bash
   export PATH="$PATH:$HOME/develop/flutter/bin"
   ```
4. Source your config:
   ```bash
   source ~/.bashrc
   ```

---

## 2. JDK & Android Command-line Tools

### OpenJDK 17
Install OpenJDK 17:
```bash
sudo apt install -y openjdk-17-jdk
```

### Android SDK and licenses
1. Download Android command-line tools zip from [developer.android.com](https://developer.android.com).
2. Extract to `~/Android/Sdk`.
3. Accept licenses:
   ```bash
   flutter doctor --android-licenses
   ```

---

## 3. Verification

Run static doctor check:
```bash
flutter doctor
```

---

## 4. Running the Project

1. Navigate to `frontend/`.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run:
   ```bash
   flutter run -d chrome  # or on a connected Android device
   ```
