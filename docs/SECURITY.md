# Security Policy

This document describes the security configurations, credential keys storage, and resource policies of KrishiOS.

---

## 🔒 Firebase Security Rules

### 1. Cloud Firestore Rules
Firestore resources are protected based on the authenticated user ID scope:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User profile permissions
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // User scans permissions
    match /users/{userId}/scans/{scanId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public community posts
    match /posts/{postId} {
      allow read: if true;
      allow write: if request.auth != null;
      
      // Comments sub-collection
      match /comments/{commentId} {
        allow read: if true;
        allow write: if request.auth != null;
      }
    }
  }
}
```

### 2. Firebase Storage Rules
Ensures uploaded crop images are only writable by their respective authors:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /scans/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 🔑 Key Management & Secrets

*   **API Credentials**: Firebase keys (stored in `google-services.json` and `GoogleService-Info.plist`) are public config parameters for app identification, not secrets. Write/read permissions are restricted via Firestore Rules.
*   **Enviroment Files**: Production config variables (e.g. backend URLs, server API keys) must be stored inside `.env` configuration files and excluded from repository commits:
    ```
    # Excluded via .gitignore
    .env
    .env.production
    ```
*   **Local Secure Caching**: Local Hive encryption keys are generated dynamically and stored using secure hardware storage keychains (such as Keychain on iOS and Keystore on Android).
