# Developer Guidelines

This document outlines the coding standards, folder conventions, and engineering workflows for developers contributing to KrishiOS.

---

## 🎨 Clean Architecture Specification

The Flutter app is structured inside `frontend/lib` using a Feature-First Clean Architecture pattern:

```
lib/features/feature_name/
├── data/
│   ├── datasources/       # Remote and local database API clients
│   └── repositories/      # Repository implementations returning parsed domain models
├── domain/
│   ├── models/            # Feature-specific models
│   └── repositories/      # Repository abstract definitions
└── presentation/
    ├── providers/         # Riverpod state providers
    ├── screens/           # Main route screens
    └── widgets/           # Sub-widgets and presentation cards
```

---

## ⚡ Riverpod State Management Rules

*   **Read vs. Watch**:
    *   Inside the `build` method of widgets, use `ref.watch(provider)` to monitor changes reactively.
    *   Inside callbacks (e.g. `onPressed`), use `ref.read(provider)` to access state values without triggering unwanted widget rebuilds.
*   **Family Providers**: Use `.family` modifier when querying parameterized futures or streams (such as post comments based on a specific ID).
*   **Keep State Clean**: Decouple database reads/writes completely from presentation widgets. UI components should only listen to state controllers or watch repositories.

---

## 📐 Coding Conventions

*   **File Naming**: All dart files must use `snake_case` (e.g. `scan_result_screen.dart`).
*   **Class Naming**: Use `PascalCase` for all classes, repositories, and models (e.g. `ScanResultScreen`).
*   **Imports Order**:
    1.  Flutter framework packages (`package:flutter/...`)
    2.  Third-party packages (e.g., `package:flutter_riverpod/...`)
    3.  Absolute application paths (e.g., `package:krishios/...`)
    4.  Relative local path imports (`../widgets/...`)

---

## 🧪 Testing Guidelines

Before submitting modifications, verify compiler checks:
1.  **Format Code**:
    ```bash
    flutter format .
    ```
2.  **Lint Check**: Run static code analysis:
    ```bash
    flutter analyze
    ```
3.  **Execute Unit/Widget Tests**:
    ```bash
    flutter test
    ```

---

## 🚀 Adding Features

### 1. Adding a Frontend Feature Screen
1. Create a subdirectory under `features/`.
2. Implement your data and repository layer mapping Firestore/Hive hooks.
3. Expose state controllers in `presentation/providers/`.
4. Build responsive presentation screens.
5. Register routes inside the bottom navigation or relevant screen transitions.

### 2. Adding Backend Endpoints
1. Open `backend/app.py`.
2. Define a FastAPI route decorator mapping parameters:
   ```python
   @app.post("/my-endpoint")
   async def my_endpoint(data: MyModel):
       return {"status": "success"}
   ```
3. Update [docs/API.md](file:///o:/Hackthons/KrishiOS/docs/API.md) with details.
