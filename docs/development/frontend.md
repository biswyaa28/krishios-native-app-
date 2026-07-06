# Frontend Development Guide

This guide details code styles, directory structure, and best practices for building KrishiOS Flutter UI components.

---

## 1. Directory Breakdown

All frontend source files reside inside `frontend/lib/`:
* **`core/`**: Central shared elements (such as `theme/` definitions, database configuration files, and geocoding network clients).
* **`features/`**: Feature-specific subdirectories (e.g., `home/`, `scan/`, `stats/`, `community/`).
* **`shared/`**: Generic UI components shared between multiple features (e.g., loading views, error cards).

---

## 2. Coding Best Practices

* **Keep build methods pure:** Avoid side-effects inside `Widget.build()` loops. Place initialization code inside `initState()` or state managers.
* **Isolate Large Widgets:** Break down complex, nested trees (e.g., lists with custom item rows) into standalone class widgets under the feature's `presentation/widgets/` folder.
* **Use abstract styles:** Do not hardcode custom sizes, typography weight, or colors inline. Reference unified properties declared in `AppTheme`, `AppColors`, and `AppTextStyles`.
* **State Management:** Place actions (such as posts additions, message updates) inside state controller adapters. Avoid using stateful variables directly inside UI screen shells.
