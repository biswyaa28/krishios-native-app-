# Installation and Setup Guide

This guide provides instructions to set up the KrishiOS development environment across different operating systems.

---

## 💻 Prerequisites

Ensure you have the following general dependencies installed:
*   **Git**: [Download Git](https://git-scm.com/downloads)
*   **Flutter & Dart SDK**: [Flutter Install Guide](https://docs.flutter.dev/get-started/install) (Ensure Flutter SDK version is `3.19.0` or higher)
*   **Python (3.9 - 3.11)**: [Download Python](https://www.python.org/downloads/)
*   **Node.js (v18+) & npm**: [Download Node.js](https://nodejs.org/) (for Web Landing Page)
*   **Firebase CLI**: Install globally using `npm install -g firebase-tools`

---

## 🪟 Windows Setup

### 1. Install Dependencies
Install the required packages using `winget` or direct installers:
```powershell
# Install Git
winget install --id Git.Git -e

# Install Python 3.10
winget install --id Python.Python.3.10 -e

# Install Node.js
winget install --id OpenJS.NodeJS -e

# Install Java Development Kit (JDK 17)
winget install --id Oracle.JDK.17 -e
```
*Note: Download and configure Android Studio to set up the Android SDK, Virtual Device Emulator, and build tools.*

### 2. Configure Monorepo Components

#### A. Backend setup
1. Navigate to the `backend/` directory:
   ```powershell
   cd backend
   ```
2. Create and activate a Python virtual environment:
   ```powershell
   python -m venv .venv
   .venv\Scripts\activate
   ```
3. Install PyTorch (CPU version) and API dependencies:
   ```powershell
   pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
   pip install fastapi uvicorn pillow python-multipart
   ```

#### B. Landing Page Setup
1. Navigate to the `web/` directory:
   ```powershell
   cd ../web
   ```
2. Install npm dependencies:
   ```powershell
   npm install
   ```

#### C. Frontend Setup
1. Navigate to the `frontend/` directory:
   ```powershell
   cd ../frontend
   ```
2. Fetch Flutter package assets:
   ```powershell
   flutter pub get
   ```

### 3. Launch Development Environment
1. **Start Emulator**: Open Android Studio ➔ Virtual Device Manager ➔ Launch Device.
2. **Start Backend**:
   ```powershell
   cd backend
   .venv\Scripts\activate
   python app.py
   ```
   *The server binds to `http://0.0.0.0:8080`. For local browser checks, use `http://localhost:8080`.*
3. **Start Landing Page**:
   ```powershell
   cd web
   npm run dev
   ```
   *Serves Vite modules locally on `http://localhost:5173`.*
4. **Start Mobile App**:
   ```powershell
   cd frontend
   flutter run
   ```

---

## 🍎 macOS Setup

### 1. Install Dependencies
Install prerequisites using Homebrew:
```bash
# Install Homebrew dependencies
brew install git python@3.10 node cocoapods

# Install Firebase CLI
npm install -g firebase-tools
```
*Configure Xcode for iOS builds: `xcode-select --install` and agree to license conditions.*

### 2. Setup iOS CocoaPods
Navigate to `frontend/ios/` and update pods:
```bash
cd frontend/ios
pod install
```

### 3. Execution Commands
*   **Run iOS Simulator**:
    ```bash
    flutter run -d ios
    ```
*   **Run Android Emulator**:
    ```bash
    flutter run -d android
    ```
*   **Run Chrome Web Target**:
    ```bash
    flutter run -d chrome
    ```

---

## 🐧 Linux Setup

### 1. Install System Packages

#### Ubuntu / Debian
```bash
sudo apt update
sudo apt install -y git python3-pip python3-venv nodejs npm openjdk-17-jdk clang cmake ninja-build pkg-config libgtk-3-dev
```

#### Arch Linux
```bash
sudo pacman -Syu git python-pip nodejs npm jdk17-openjdk clang cmake ninja pkg-config gtk3
```

#### Fedora
```bash
sudo dnf install -y git python3-pip nodejs openjdk-17-devel clang cmake ninja-build pkgconf-pkg-config gtk3-devel
```

### 2. Execution Target
Run on desktop Linux target:
```bash
flutter run -d linux
```
