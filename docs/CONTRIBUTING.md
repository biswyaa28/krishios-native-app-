# Contributing to KrishiOS AI

We welcome contributions to the KrishiOS AI project. Please follow these guidelines to ensure a smooth collaboration process.

## Branch Strategy

Follow a branch naming convention when developing new features or resolving issues:

- `main`
- `develop` (optional)
- `feature/<feature-name>`

### Examples

- `feature/ai-training`
- `feature/api`
- `feature/inference`

---

## Commit Message Convention

Use Conventional Commits.

### Examples

- `feat(ai): add EfficientNet training pipeline`
- `fix(api): handle invalid image uploads`
- `docs(readme): update project structure`
- `refactor(training): improve dataset loader`
- `test(inference): add prediction tests`

---

## Code Style

- Follow PEP 8.
- Use type hints.
- Use `pathlib` instead of `os.path` whenever possible.
- Add docstrings to all public functions.
- Avoid duplicate code.
- Keep functions small and reusable.

---

## Folder Responsibilities

The `ai` directory is organized into the following components:

- **api**: Web API interfaces, routes, endpoints, and server application logic.
- **configs**: Configuration parameters, training options, and hyperparameter specifications.
- **dataset**: Scripts and helpers for data downloading, ingestion, and initial pipeline setups.
- **inference**: Scripts and classes for running model predictions and evaluations on new data.
- **models**: Neural network architectures, model declarations, and model configurations.
- **notebooks**: Jupyter notebooks for exploratory data analysis (EDA), experiments, and visualizations.
- **outputs**: Folder where output logs, visualization images, training metrics, and checkpoints are stored.
- **scripts**: Utility and executable scripts for automating various workspace tasks.
- **tests**: Unit tests, integration tests, and test suite definitions for validating the codebase.
- **training**: Training loops, pipelines, hyperparameter search, and optimization scripts.
- **utils**: Shared helper functions, logging configurations, and common operations.

---

## Pull Request Checklist

- Code builds successfully
- Tests pass
- No dataset committed
- No trained models committed
- Code follows formatting guidelines
- Documentation updated if necessary

---

## Do Not Commit

Never commit:

- datasets
- trained models
- virtual environments
- logs
- cache files
- generated outputs
