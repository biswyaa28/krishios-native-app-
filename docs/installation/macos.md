# macOS Developer Setup Guide

This guide describes how to configure a developer environment on macOS to build, run, and test KrishiOS.

---

## 1. Prerequisites

### Xcode & Command Line Tools
1. Install **Xcode** from the Mac App Store.
2. Once installed, launch Xcode to accept the license agreement.
3. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

### Homebrew (Recommended package manager)
Install Homebrew from [brew.sh](https://brew.sh):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Flutter SDK
1. Download the Flutter stable SDK from [flutter.dev](https://docs.flutter.dev/get-started/install/macos/desktop).
2. Extract the file to a clean directory (e.g., `~/develop/flutter`).
3. Add the bin folder to your shell PATH (e.g., in `~/.zshrc`):
   ```bash
   export PATH="$PATH:$HOME/develop/flutter/bin"
   ```
4. Reload shell configuration:
   ```bash
   source ~/.zshrc
   ```

### CocoaPods
CocoaPods is required to manage iOS/macOS native framework plugins:
```bash
brew install cocoapods
```

---

## 2. Java Development Kit (JDK) 17

Install JDK 17 using Homebrew:
```bash
brew install openjdk@17
```
Symlink the system java wrapper:
```bash
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
```

Configure shell environment variable (`~/.zshrc`):
```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
```

---

## 3. Verification & Doctor Checks

Run Flutter doctor:
```bash
flutter doctor
```
Ensure Xcode and Android toolchain targets resolve successfully.

---

## 4. Running the Project

1. Navigate to `frontend/`:
   ```bash
   cd frontend
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Boot an iOS simulator or connect a test device.
4. Launch the application:
   ```bash
   flutter run
   ```
