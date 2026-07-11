# Project Directory Structure

This document outlines the folder layout of the KrishiOS monorepo.

---

## 📂 Root Structure

```
KrishiOS/
│
├── ai/                # AI model compilation scripts & raw training weights
├── backend/           # FastAPI REST inference service
├── frontend/          # Flutter cross-platform mobile application
├── web/               # Vite-based HTML/CSS Product Landing Page
├── docs/              # Monorepo technical documentation
├── deployment/        # Docker and deployment configurations
├── scripts/           # Automation tooling and cleanup commands
└── README.md          # Project root readme
```

---

## 🔍 Module Responsibilities

### 1. `ai/`
Manages AI training routines and neural networks:
*   `models/`: Stores compile-ready binary models (`model.ts`).
*   `training/`: Contains python notebooks and scripts to train torchvision classifiers on the PlantVillage dataset.

### 2. `backend/`
Handles REST endpoints and CPU forward inference:
*   `app.py`: FastAPI server binding endpoints (`/predict`, `/health`) and loading standard CORS configs.

### 3. `frontend/`
Flutter codebase compiled using Riverpod and Clean Architecture:
*   `lib/core/`: Application themes, base navigation setups, and routing styles.
*   `lib/features/`: Feature-first code slices containing presentation widgets, providers, repositories, and data sources (e.g. auth, community, scan, weather).
*   `lib/shared/`: Global models (e.g. `ScanResult`, `UserProfile`) and Hive caching database layers.

### 4. `web/`
Product Landing page:
*   Built using Vite + HTML5 + CSS3 to introduce KrishiOS features, statistics, and platform support to judges and users. *This is distinct from the Flutter Web target.*

### 5. `docs/`
Developer and integration directories mapping monorepo features, installations, and architecture schemas.

### 6. `deployment/`
Configures build setups, container environments, and dockerfiles for staging/production deployments of the AI backend.

### 7. `scripts/`
Helper scripts for repository maintenance, automated linting, test executions, and caches clearing.
