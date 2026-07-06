# Contributing to KrishiOS

We welcome contributions from the community! This document outlines guidelines to help you contribute to KrishiOS development.

---

## 1. Code of Conduct

By contributing, you agree to respect and follow the [Code of Conduct](CODE_OF_CONDUCT.md) guidelines.

---

## 2. Getting Started

1. Fork the repository on GitHub.
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/KrishiOS.git
   ```
3. Set up the development workspace by following the [Installation Guides](docs/installation/windows.md).

---

## 3. Contribution Workflow

### Step 1: Create a Branch
Always develop inside a feature/bugfix branch:
```bash
git checkout -b feature/your-feature-name
```

### Step 2: Code & Format
Before committing, make sure you format and analyze the Flutter code:
```bash
dart format .
flutter analyze
```

### Step 3: Run Tests
Run automated tests to ensure no regressions are introduced:
```bash
flutter test
```

### Step 4: Commit
Write semantic commit messages:
```bash
git commit -m "feat(scan): add camera preview screen"
```

### Step 5: Pull Request
Push to your fork and submit a Pull Request targeting the `develop` or `main` branch.
