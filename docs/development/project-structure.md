# Project Structure & Architecture Guide

This document maps directories and module responsibilities across the KrishiOS monorepo.

---

## 1. Directory Tree Overview

```text
KrishiOS/
├── .github/                 # CI/CD Workflows & issue/PR templates
├── ai/                      # Independent PyTorch training module
│   ├── configs/             # Hyperparameter settings
│   ├── dataset/             # Raw dataset folder (ignored)
│   ├── models/              # Exported checkpoints (.pth, .ts, .onnx)
│   ├── notebooks/           # Jupyter exploration notebooks
│   └── training/            # PyTorch pipeline source scripts
├── deployment/              # Release scripts and server deployment settings
├── docs/                    # Complete developer & setup guides
│   ├── installation/        # OS and SDK installation tutorials
│   ├── development/         # Code architecture and style policies
│   ├── deployment/          # Build and release packaging guides
│   └── api/                 # API endpoint specifications
├── frontend/                # Flutter Workspace
│   ├── assets/              # Graphics, fonts, and model assets
│   ├── lib/                 # Feature-First architecture source code
│   │   ├── core/            # Central network & theme configs
│   │   └── features/        # Modular components (home, scan, stats)
│   ├── test/                # Flutter automated testing suites
│   └── platform directories # android, ios, macos, web, windows, linux
├── scripts/                 # Utility execution scripts
├── tools/                   # Developer automation tools
├── LICENSE                  # Unified Apache 2.0 license file
├── README.md                # Project documentation index
└── task.md                  # Project task tracking checklist (ignored)
```

---

## 2. Directory Responsibilities

### **Root Module (`/`)**
Acts as the monorepo coordinator containing unified documentation, project roadmap targets, and build scripts.

### **Flutter Application (`/frontend/`)**
Contains the user-facing application built with Flutter.
* **`lib/core/`**: Implements global services (e.g., location coordinates retrieval, meteo API client calls, and theme configurations).
* **`lib/features/`**: Groups screens, widgets, data, and models by cohesive business features (e.g., `scan` for disease diagnostic frames, `community` for user forums).

### **AI Core (`/ai/`)**
Acts as a standalone machine learning module.
* **`training/`**: Preprocesses training dataset images, configures transfer learning backbones (EfficientNet-B0), executes epochs loops, and plots metrics.
* **`notebooks/`**: Provides interactive data exploration, Grad-CAM visualization, and ONNX conversion pipelines.
