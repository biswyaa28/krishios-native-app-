# Project Development Roadmap

This roadmap outlines planned milestones to transition the KrishiOS application mockup into a production-ready agriculture assistant.

---

## 📅 Phase 1: Edge AI Optimization
* Convert trained PyTorch weights (`best_model.pth`) to optimized ONNX (`model.onnx`).
* Apply INT8 quantization to compress size under 5MB for low-resource devices.
* Standardize PlantVillage label configuration lists mapping folders.

---

## 📅 Phase 2: Hardware Camera Integration
* Integrate the official Flutter `camera` plugin.
* Implement custom viewport overlay frameworks inside the scan screen.
* Add image compression/rotation pipelines for local tensor pre-processing.

---

## 📅 Phase 3: Offline Database Support
* Integrate `isar` NoSQL database.
* Save scan history metadata, geolocation coordinates, and diagnostic notes locally.
* Implement offline cache policies for weather coordinates data.

---

## 📅 Phase 4: Production Backend
* Build FastAPI server linked to PostgreSQL databases.
* Expose endpoints for JWT auth verification, community feed sync, and backups.
