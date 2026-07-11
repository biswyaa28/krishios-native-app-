# Troubleshooting Guide

This guide covers common issues encountered during development and execution of KrishiOS.

---

## 📱 Flutter & Android Emulator Issues

### 1. Emulator connection timeout or offline
*   **Symptom**: `flutter devices` reports `emulator-5554 is offline` or fails to detect the emulator.
*   **Solution**:
    1. Close the emulator and wipe its user data in the Android Device Manager.
    2. Restart the ADB server:
       ```bash
       adb kill-server
       adb start-server
       ```
    3. Run `flutter emulators --launch Pixel_8` again.

### 2. Camera permission exception or crash on startup
*   **Symptom**: App crashes when navigating to the Scan tab.
*   **Solution**: Ensure camera permissions are configured inside:
    *   **Android (`AndroidManifest.xml`)**:
        ```xml
        <uses-permission android:name="android.permission.CAMERA" />
        ```
    *   **iOS (`Info.plist`)**:
        ```xml
        <key>NSCameraUsageDescription</key>
        <string>KrishiOS requires camera access to scan crop leaves.</string>
        ```

### 3. Gradle build errors (aar compatibility)
*   **Symptom**: Build fails on Android compile stage.
*   **Solution**: Standardize `compileSdk` and `targetSdk` to `36` inside `frontend/android/app/build.gradle.kts`.

---

## 🐍 Python & FastAPI Backend Issues

### 1. Address already in use (Port 8080 conflicts)
*   **Symptom**: FastAPI server crashes on startup with `OSError: [Errno 98] Address already in use`.
*   **Solution**: Port `8080` is occupied by another local service. Locate the process ID and terminate it, or change the port parameter:
    *   **Windows**:
        ```powershell
        Stop-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess -Force
        ```
    *   **Port Override**:
        ```bash
        python app.py --port 8081
        ```

### 2. CORS blocks client requests
*   **Symptom**: Web client reports browser block console errors.
*   **Solution**: Ensure wildcards (`"*"`) are enabled inside `CORSMiddleware` inside `app.py`.

### 3. TorchScript model file not found
*   **Symptom**: Backend runs in mock fallback mode.
*   **Solution**: Ensure you have placed `model.ts` inside `ai/models/`. Confirm that the relative path resolved in `app.py` points correctly to the target folder.
