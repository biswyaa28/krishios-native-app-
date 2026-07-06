# Architecture Design Guide

KrishiOS uses a **Feature-First Clean Architecture** design layout to structure code modules, ensure high maintainability, and isolate UI presentation components from core device APIs and domain-level logical rules.

---

## 1. Core Architecture Principles

1. **Independent Domain:** The core domain model representing data entities (e.g., `Weather`, `CommunityPost`, `ChatMessage`) is independent of any database libraries, UI layout controls, or remote services.
2. **Layer Separation:**
   - **Presentation Layer (`presentation/`):** Contains UI widgets, views, controller hooks, and rendering logic.
   - **Domain Layer (`domain/`):** Contains business data entities and use cases.
   - **Data Layer (`data/`):** Contains local model datasheets, API providers, caches, repositories, and data source wrappers.
3. **Dependency Flow:** All dependencies point inward. The `presentation` and `data` layers depend on the abstract definitions inside the `domain` layer.

---

## 2. Directory Structure

Inside `lib/features/`:
```text
<feature_name>/
├── data/
│   ├── datasources/  # REST clients, database readers
│   ├── models/       # Raw data serialization models
│   └── repositories/ # Repository implementations
├── domain/
│   ├── entities/     # Pure Dart entity classes
│   ├── repositories/ # Repository interfaces (abstract classes)
│   └── usecases/     # Unit business rules
└── presentation/
    ├── screens/      # Complete screen pages
    ├── widgets/      # Isolated reusable sub-widgets
    └── state/        # State managers and providers
```
