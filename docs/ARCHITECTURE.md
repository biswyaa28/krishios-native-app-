# System Architecture

This document describes the high-level architecture, data flows, and sub-system integrations of the KrishiOS Monorepo.

---

## 🏗️ System Components

KrishiOS is divided into three key layers:
1.  **Client Application (Frontend)**: Flutter cross-platform app (Android/iOS/Web) compiled using clean architecture principles and Riverpod state management.
2.  **Cloud & Database Layer (Firebase)**: Manages cloud storage buckets, document models, and security permissions.
3.  **Inference Server (AI Backend)**: FastAPI microservice exposing PyTorch endpoints to process leaf pathology classifications.

```mermaid
graph TD
    Client[Flutter Client Mobile/Web] <-->|Auth / Firestore / Storage| Firebase[Firebase Services]
    Client <-->|REST API /predict| FastAPI[FastAPI Backend]
    FastAPI <-->|Local Model Path| TorchScript[TorchScript CPU Model]
```

---

## 🔄 Core Flows

### 1. Authentication Flow
Authenticates user sessions or allows Guest mode bypasses.
```mermaid
sequenceDiagram
    participant User as User Screen
    participant Shell as MainShell (Riverpod)
    participant Auth as Firebase Auth
    participant DB as Cloud Firestore

    User->>Shell: Launch App
    Shell->>Auth: Check currentUser session
    alt Session Active
        Auth-->>Shell: Return User profile
        Shell->>User: Route to Home Dashboard
    else Session Expired
        Auth-->>Shell: Return null
        Shell->>User: Route to Auth Login Screen
        User->>Shell: Tap Continue as Guest
        Shell->>User: Route to Home Dashboard (Mock Auth state)
    end
```

### 2. Crop Scan Flow
The process of capturing, classifying, and saving crop diagnostic results.
```mermaid
sequenceDiagram
    participant App as CropScanScreen (Flutter)
    participant Storage as Firebase Storage
    participant API as FastAPI Backend
    participant Torch as TorchScript Model
    participant DB as Cloud Firestore

    App->>App: Capture Leaf Photo (Camera/Gallery)
    App->>Storage: Upload JPEG under /scans/{userId}/
    Storage-->>App: Return Public CDN Download URL
    App->>API: POST multipart image to /predict
    API->>Torch: Preprocess & forward pass inference
    Torch-->>API: Return class index & confidence
    API-->>App: Return Diagnosis Name & Confidence JSON
    App->>DB: Write scan metadata + CDN URL to users/{uid}/scans
    App->>App: Push ScanResultScreen (Detailed Report UI)
```

### 3. Weather Flow
Geolocation coordinates weather alerts.
```mermaid
sequenceDiagram
    participant App as WeatherCard
    participant GPS as Geolocator API
    participant API as Open-Meteo REST API

    App->>GPS: Request device coordinates
    GPS-->>App: Return Lat/Lon coordinates
    App->>API: Query /v1/forecast?latitude=x&longitude=y
    API-->>App: Return 7-day temperature & humidity metrics
    App->>App: Render dynamic charts and warning widgets
```

### 4. Community forum Flow
Dynamic comment listing and updates.
```mermaid
sequenceDiagram
    participant UI as CommunityScreen
    participant Repo as CommunityRepository
    participant DB as Cloud Firestore

    UI->>Repo: Subscribe to getPosts(category) stream
    DB-->>UI: Emits real-time document collection snapshots
    UI->>UI: Render posts list
    UI->>Repo: toggleLike(postId)
    Repo->>DB: Increment/Decrement likesCount field
```
