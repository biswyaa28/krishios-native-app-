# Coding Standards & Guidelines

This document details style guidelines and coding rules for KrishiOS.

---

## 1. Dart & Flutter Coding Standards

* **Naming Conventions:**
  - Classes, extension types: `PascalCase`.
  - Directories, source files, asset keys: `snake_case`.
  - Variables, functions, parameters: `camelCase`.
* **Lint Constraints:** We follow the lint configurations set in `analysis_options.yaml`. Make sure to run the formatting check before committing:
  ```bash
  dart format .
  flutter analyze
  ```
* **Immutability:** Mark class fields as `final` wherever possible. Use `const` constructors on widgets to optimize rendering performance.

---

## 2. Python Coding Standards

* **PEP 8 Rules:** We adhere strictly to PEP 8 standards. Naming details:
  - Class names: `CamelCase`.
  - Functions, scripts, methods: `snake_case`.
  - Constants: `UPPERCASE_SNAKE_CASE`.
* **Imports:** Sort imports in groups: standard libraries, third-party libraries, and local project modules.
