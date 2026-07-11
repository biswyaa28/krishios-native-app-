# KrishiOS Project Roadmap

This document maps out the current release state, work in progress, and future milestones.

---

## 📊 Current Release Status

| Component | Status | Percentage | Key Features |
| :--- | :--- | :--- | :--- |
| **Frontend Mobile App** | Completed | 100% | Navigation shells, weather lookup, logs history, detailed reports, community comments. |
| **FastAPI REST Service** | Completed | 100% | TorchScript forward pass execution, health status telemetry, CORS integration. |
| **AI Model Pipeline** | Completed | 100% | PyTorch traced compilation (`model.ts`), image pre-processing normalization. |
| **Database & Cloud Sync** | Completed | 100% | Firebase Auth login, Storage uploads, Firestore real-time thread synchronization, secure local Hive cache. |
| **Vite Landing Page** | Completed | 100% | Product landing page showcase. |

---

## 🔄 Development Phases

### Phase 1: Local & Cloud Core (Completed)
*   [x] Set up Clean Architecture structure in Flutter.
*   [x] Connect Firebase Authentication.
*   [x] Configure secure local encrypted Hive boxes.
*   [x] Construct FastAPI inference server.

### Phase 2: User Experience & Diagnostics (Completed)
*   [x] Implement image uploads to Firebase Storage.
*   [x] Connect camera viewport snapshot diagnostic captures.
*   [x] Create detailed diagnosis reports with chemical and organic treatments.
*   [x] Integrate filterable logs search inside history.
*   [x] Establish interactive comment boards.

### Phase 3: Hardware & Offline Scale (Planned)
*   [ ] **On-Device Offline AI**: Implement ONNX Runtime to run inference offline directly on client smartphones.
*   [ ] **IoT Sensor Integration**: Sync ESP32 soil nitrogen, moisture, and temperature sensors to the dashboard.
*   [ ] **Multilingual Support**: Add localized translation guides (Hindi, Spanish, Telugu).
*   [ ] **Voice Assistant**: Build a voice advisory system.
*   [ ] **Marketplace**: Add peer-to-peer fertilizer trading.
