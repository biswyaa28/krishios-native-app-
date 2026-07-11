# Database Schema Guide

This document describes the schema architecture, document mapping, and local storage configurations of the KrishiOS application.

---

## ☁️ Cloud Firestore Schema

Firestore is organized in a document-based hierarchical model under specific collections:

### 1. `users` Collection
Stores user profiles and roles:
*   **Path**: `users/{userId}`
*   **Fields**:
    ```json
    {
      "uid": "String (Document ID)",
      "name": "String (Display name)",
      "email": "String (User email)",
      "avatarUrl": "String? (Optional profile CDN link)",
      "role": "String (Farmer / Expert)",
      "createdAt": "Timestamp"
    }
    ```

### 2. `users/{userId}/scans` Sub-collection
Tracks diagnostic pathology history for the authenticated scope:
*   **Path**: `users/{userId}/scans/{scanId}`
*   **Fields**:
    ```json
    {
      "id": "String (Unique ID)",
      "cropName": "String (e.g. Tomato)",
      "fieldName": "String (e.g. Main Field)",
      "diagnosis": "String (e.g. Late Blight)",
      "healthScore": "Double (0.0 to 100.0)",
      "scannedAt": "Timestamp",
      "imagePath": "String (Firebase Storage download URL)",
      "confidence": "Double (0.0 to 1.0)",
      "treatment": "String (Suggested actions)",
      "latitude": "Double? (Location coordinates)",
      "longitude": "Double? (Location coordinates)",
      "userId": "String"
    }
    ```

### 3. `posts` Collection
Coordinates thread messages inside the community board:
*   **Path**: `posts/{postId}`
*   **Fields**:
    ```json
    {
      "authorId": "String",
      "authorName": "String",
      "authorAvatar": "String?",
      "authorRole": "String",
      "title": "String",
      "body": "String",
      "category": "String (Trending / General / Q&A / Alerts)",
      "imageUrl": "String?",
      "likesCount": "Integer (Real-time count)",
      "commentsCount": "Integer (Real-time count)",
      "createdAt": "ServerTimestamp",
      "isExpert": "Boolean"
    }
    ```

### 4. `posts/{postId}/comments` Sub-collection
Nested thread lists for discussion updates:
*   **Path**: `posts/{postId}/comments/{commentId}`
*   **Fields**:
    ```json
    {
      "text": "String",
      "authorId": "String",
      "authorName": "String",
      "createdAt": "ServerTimestamp"
    }
    ```

---

## 🔒 Local Encrypted Caching (Hive)

To ensure secure offline operations, KrishiOS utilizes locally encrypted Hive boxes:
*   **Weather Box (`weatherBox`)**: Caches coordinate forecasts for offline widgets.
*   **Scan Box (`scanHistoryBox`)**: Stores diagnostic logs.
*   **Prefs Box (`userPrefsBox`)**: Caches dark theme, language choice, and notification settings.

### Encryption Protocol (AES-256)
Upon startup, the app checks for an encryption key inside the Secure Storage device registry. If missing, it generates a cryptographically secure 256-bit key and wraps the Hive box using `HiveAesCipher` to encrypt local device files.
