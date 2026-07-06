# Release Checklist & Process

This checklist outlines target processes before releasing new updates of KrishiOS.

---

## 1. Release Checklist

- [ ] All widget testing suites pass successfully (`flutter test`).
- [ ] Static analyzer reports zero errors (`flutter analyze`).
- [ ] Version and build numbers have been bumped in `pubspec.yaml` (e.g. `version: 1.0.1+2`).
- [ ] Changelog has been updated in `CHANGELOG.md` detailing new improvements.
- [ ] Keystore passwords and profile credentials are set securely in deployment environment variables.

---

## 2. Release Steps

1. Merge the feature branch into `develop`, and then `main` after approvals.
2. Tag the release commit:
   ```bash
   git tag -a v1.0.1 -m "Release version 1.0.1"
   git push origin v1.0.1
   ```
3. Run the automated CI build script on GitHub Actions to auto-release binary packages.
