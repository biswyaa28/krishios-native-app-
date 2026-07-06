# Git Branching & Workflow Guidelines

This document details Git branching, commit conventions, and pull request policies.

---

## 1. Branch Naming Policies

Create descriptive branch names prefixing them with their functional area:
* **`feature/`**: New feature development (e.g. `feature/camera-capture`).
* **`bugfix/`**: Standard bug patches (e.g. `bugfix/location-permission`).
* **`hotfix/`**: Critical runtime bug fixes.
* **`docs/`**: Documentation updates.

---

## 2. Commit Message Conventions

We use semantic commit messages:
* **`feat:`**: A new feature implementation.
* **`fix:`**: A bug correction.
* **`docs:`**: Documentation-only changes.
* **`refactor:`**: A code change that neither fixes a bug nor adds a feature.
* **`test:`**: Adding or correcting test suites.

Example:
`feat(scan): add local onnx classifier inference engine`

---

## 3. Pull Request Guidelines

1. Always submit pull requests targeting the `main` or `develop` branch.
2. Verify compile checks before submitting:
   - All tests pass (`flutter test`).
   - Static analysis is clean (`flutter analyze`).
3. Link related issues inside the PR description.
