# KrishiOS - Offline-First AI Farming Assistant

---

## 1. Introduction

KrishiOS is a mobile assistant application designed to assist smallholder farmers in remote areas. It leverages Computer Vision and Edge AI to diagnose crop diseases and suggest recovery steps entirely offline.

---

## 2. Key Features

* **Offline Disease Diagnosis:** Performs on-device image classification on leaf images using an optimized edge model (EfficientNet-B0) to detect 38 distinct crop states.
* **Agricultural Weather Forecasts:** Fetches real-time localized current weather and precipitation forecasts using geolocator coordinates and the Open-Meteo REST API.
* **Community Forum:** Enables farmers to share posts, comments, and advice locally with neighboring fields.
* **Performance Analytics:** Provides custom circular gauges and health charts detailing crop yield analytics.

---

## 3. Technology Stack

* **Frontend:** Flutter stable (Dart)
* **Edge AI:** ONNX Runtime / TensorFlow Lite (Inference)
* **Training Core:** PyTorch (EfficientNet-B0 Backbone)
* **Backend (Future):** FastAPI (Python) & PostgreSQL

---

## 4. Repository Structure

```text
KrishiOS/
├── .github/             # Automated CI workflows and issue templates
├── ai/                  # AI Model training (PyTorch code, configs, datasets)
├── docs/                # Developer guides and OS setup files
└── frontend/            # Flutter app (screens, themes, location services)
```
For a detailed overview, see [docs/development/project-structure.md](docs/development/project-structure.md).

---

## 5. Quick Start (Running Locally)

### Prerequisites
* Flutter SDK (Stable channel)
* JDK 17
* Android Studio / Xcode

### Setup Flutter
1. Navigate to the client directory:
   ```bash
   cd frontend
   ```
2. Download packages:
   ```bash
   flutter pub get
   ```
3. Run on a connected device/emulator:
   ```bash
   flutter run
   ```

---

## 6. Documentation Index

For detailed instructions, refer to our comprehensive documentation directory:
* **Developer Setup:**
  - [Windows Setup Guide](docs/installation/windows.md)
  - [macOS Setup Guide](docs/installation/macos.md)
  - [Linux Setup Guide](docs/installation/linux.md)
  - [Android Target Guide](docs/installation/android.md)
  - [iOS Target Guide](docs/installation/ios.md)
* **Technical Guidelines:**
  - [Architecture Design Details](docs/development/architecture.md)
  - [Coding Standards & Styles](docs/development/coding-guidelines.md)
  - [Git Branching & Pull Requests](docs/development/git-workflow.md)
* **Distribution & Deployment:**
  - [Android Packaging Guide](docs/deployment/android.md)
  - [iOS Packaging Guide](docs/deployment/ios.md)
  - [Release Guidelines](docs/deployment/release.md)
* **Troubleshooting:**
  - [Troubleshooting Common Compile Bugs](docs/installation/troubleshooting.md)

---

## 7. Contributing

We welcome contributions from the community! Please read our [Contributing Guidelines](docs/CONTRIBUTING.md) to get started.

---

## 8. License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 9. Core Team (4 Brains)

* **Sneha** (Team Leader) — [LinkedIn Profile](https://www.linkedin.com/in/)
* **Biswajit** (AI Development) — [LinkedIn Profile](https://www.linkedin.com/in/)
* **Paarshivi** (Frontend Development) — [LinkedIn Profile](https://www.linkedin.com/in/)
* **Zoro** (AI Development & Backend Integration) — [LinkedIn Profile](https://www.linkedin.com/in/)
