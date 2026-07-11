# Contributing to KrishiOS

We welcome contributions from developers, agronomists, and AI engineers. This guide explains how to get started.

---

## 🛠️ Developer Workflow

1.  **Fork the Repository**: Create a fork of the KrishiOS repository.
2.  **Create a Feature Branch**:
    ```bash
    git checkout -b feature/your-feature-name
    ```
3.  **Implement Your Changes**: Adhere to the code guidelines specified in [DEVELOPMENT.md](file:///o:/Hackthons/KrishiOS/docs/DEVELOPMENT.md).
4.  **Run Diagnostics**: Ensure lint checks and test suites pass completely:
    ```bash
    flutter analyze
    flutter test
    ```
5.  **Commit Your Code**: Follow standard commit message guidelines.
6.  **Open a Pull Request**: Submit your branch to the main repository for review.

---

## 📝 Commit Message Guidelines

To maintain a clean repository history, commit messages must follow this structure:
```
<type>(<scope>): <short description>
```

### Supported Types:
*   `feat`: A new feature implementation.
*   `fix`: A bug fix.
*   `docs`: Documentation updates.
*   `refactor`: Code changes that do not fix a bug or add a feature.
*   `test`: Adding or correcting tests.
*   `chore`: Project build, tooling, or package dependency adjustments.

### Examples:
*   `feat(scan): add native share report action to diagnostics`
*   `fix(auth): resolve loading spinner timeout on login`
*   `docs(api): update swagger schemas for batch predict`

---

## 🐛 Submitting Issue Reports

When reporting a bug, please include:
*   A clear description of the behavior.
*   Steps to reproduce the bug.
*   Logs or console output.
*   Details about your development platform (Android emulator version, OS, Flutter Doctor output).
