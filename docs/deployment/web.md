# Web Build & Deployment Guide

This guide describes how to compile the web application for deployment on static hosting providers (such as GitHub Pages, Firebase Hosting, or Netlify).

---

## 1. Web Compilation

To compile static HTML/JS/CSS assets:
```bash
cd frontend
flutter build web --release
```

The output build assets are written to the directory:
`build/web/`

---

## 2. Deploying to Firebase Hosting

Ensure `firebase-tools` is installed, then login and initialize:
```bash
firebase login
firebase init hosting
```
Specify the public folder directory path as `build/web`.

Deploy the app:
```bash
firebase deploy --only hosting
```
