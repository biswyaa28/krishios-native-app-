# How to Run KrishiOS

> All commands run from the project root.

---

## Setup (one-time)

```bash
# 1. Create Python virtual environment & install dependencies
cd backend && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && pip install ultralytics && deactivate

# 2. Configure environment files
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

---

## Run

### Backend (required for all platforms)

```bash
cd backend && source .venv/bin/activate && python app.py
```

### Frontend

| Platform | Command |
|----------|---------|
| **iOS Simulator** | `xcrun simctl boot "iPhone 17 Pro" 2>/dev/null; open -a Simulator && flutter run -d 'iPhone 17 Pro'` |
| **Chrome (web)**  | `flutter run -d chrome` |
| **macOS (desktop)** | `flutter run -d macos` |
| **Android**       | `flutter run` (device must be connected) |

> List available devices: `flutter devices`. Omit `-d` to pick interactively.

### One-liner (iOS)

Boots simulator, starts backend, launches app:

```bash
xcrun simctl boot "iPhone 17 Pro" 2>/dev/null; open -a Simulator && (cd backend && source .venv/bin/activate && python app.py) & (cd frontend && flutter run -d 'iPhone 17 Pro')
```

### Website (Landing Page + Interactive Experience)

Both run from the same Next.js app on `http://localhost:3000`:

```bash
cd website && npm install && npm run dev
```

Then open in your browser:

| Page | URL | What it is |
|------|-----|-----------|
| **Landing Page** | `http://localhost:3000` | Marketing site (Hero, Features, Download, Team, Footer) |
| **Interactive Experience** | `http://localhost:3000/experience` | 14-scene cinematic presentation (Fullscreen, Arrow keys to navigate, `P` for presenter HUD) |
| **Flutter Web App** | `http://localhost:3000/app` | Compiled KrishiOS app served as static files |

> The `/api/*` requests are proxied to the Python backend (`http://127.0.0.1:8000`) via `next.config.ts` rewrites, so start the backend first for live AI inference.

### Production build (optional)

```bash
cd website && npm run build && npm run start
```

---

## Verify

```bash
flutter doctor && flutter analyze && flutter test
```
