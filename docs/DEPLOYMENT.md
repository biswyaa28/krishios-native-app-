# Production Deployment Guide

This document describes build packaging, hosting setups, and server deployments for KrishiOS.

---

## 📱 Android App Deployment

### 1. Build Debug APK (For local test reviews)
```bash
cd frontend
flutter build apk --debug
```
*Output file: `build/app/outputs/flutter-apk/app-debug.apk`*

### 2. Build Release APK
```bash
flutter build apk --release
```
*Output file: `build/app/outputs/flutter-apk/app-release.apk`*

### 3. Build Android App Bundle (AAB - for Google Play Store upload)
```bash
flutter build appbundle --release
```
*Output file: `build/app/outputs/bundle/release/app-release.aab`*

---

## 🍏 iOS App Deployment

1. Configure Bundle ID, App Groups, and Signing Certificates inside Xcode.
2. Build iOS release archives:
   ```bash
   flutter build ipa --release
   ```
3. Upload to TestFlight or App Store Connect using Xcode Transporter.

---

## 🌐 Web Landing Page Deployment (Vite)

1. Navigate to the `web/` directory:
   ```bash
   cd web
   ```
2. Build production assets:
   ```bash
   npm run build
   ```
3. Deploy the compiled `dist/` folder to Vercel, Netlify, or Firebase Hosting:
   ```bash
   firebase deploy --only hosting:landing
   ```

---

## 🐍 FastAPI Backend Deployment

The Python REST backend can be deployed using Docker.

### 1. Build Docker Image
```bash
docker build -t krishios-backend -f deployment/Dockerfile .
```

### 2. Run Container (Exposing port 8080)
```bash
docker run -d -p 8080:8080 --name krishios-ai krishios-backend
```

---

## 🔥 Firebase Services Deployment

Deploy Firebase Security Rules for Firestore and Storage buckets:
```bash
# Deploy Firestore rules and indexes
firebase deploy --only firestore

# Deploy Storage security rules
firebase deploy --only storage
```
