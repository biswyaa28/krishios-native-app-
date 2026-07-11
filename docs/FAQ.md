# Frequently Asked Questions (FAQ)

This FAQ answers 30 common questions about setup, architecture, AI, and debugging in KrishiOS.

---

### 1. General Project Questions

#### Q1: What is KrishiOS?
KrishiOS is a monorepo platform that implements AI crop leaf disease diagnostics, weather analysis, and farmer community message boards.

#### Q2: What is the folder structure?
It is structured as a standard monorepo: `frontend/` (Flutter), `backend/` (FastAPI + PyTorch), `web/` (Vite Landing Page), `ai/` (Model scripts), `docs/` (Guides).

#### Q3: Which platforms are supported?
The frontend supports Android, iOS, Windows, macOS, Linux, and Web targets.

#### Q4: Is the AI inference run on-device or on a server?
It is run on the FastAPI server using a compiled TorchScript model, with local mock fallbacks if the server is unreachable.

#### Q5: Is the project suitable for production?
Yes, it utilizes Clean Architecture, Riverpod state management, encrypted local Hive cache databases, and standard Firestore schemas.

---

### 2. Local Setup & Installation

#### Q6: How do I run the Android application?
Navigate to `frontend/` and run `flutter run -d emulator-5554` (or your active emulator id).

#### Q7: How do I run the iOS application?
Configure CocoaPods (`pod install` in `frontend/ios`) and run `flutter run -d ios`.

#### Q8: How do I start the AI backend?
Navigate to `backend/` and run `python app.py`.

#### Q9: How do I launch the Vite web landing page?
Navigate to `web/` and run `npm run dev`.

#### Q10: Why does http://0.0.0.0:8080 show an error in my web browser?
`0.0.0.0` is a non-routable wildcard listener address. Use `http://localhost:8080/docs` to view the API locally.

---

### 3. AI & PyTorch Model

#### Q11: Which AI model is used?
A torchvision ResNet50 classifier trained on the PlantVillage dataset.

#### Q12: What is a TorchScript model (.ts)?
A serialized PyTorch model binary that can run inside C++/Python without loading model source code files.

#### Q13: How do I compile model weights to TorchScript?
Execute a python script using `torch.jit.trace` or `torch.jit.script` and save the outputs to `ai/models/model.ts`.

#### Q14: Can I run inference offline?
Not currently on the production model. However, the client app implements local fallback rules if the FastAPI server is offline.

#### Q15: How can I change the supported crop classifications?
Edit the `CLASS_NAMES` list inside `backend/app.py` to match your newly trained model labels.

---

### 4. Firebase Configuration

#### Q16: How is Firebase Authentication configured?
Authentication is handled via the `firebase_auth` package. Credentials are authenticated against email/password or Google credentials.

#### Q17: Where do I place the Firebase config files?
Place `google-services.json` inside `frontend/android/app/` and `GoogleService-Info.plist` inside `frontend/ios/Runner/`.

#### Q18: What are the Firestore database schemas?
 Firestore utilizes user profiles (`users/`), diagnostic history (`users/{id}/scans/`), and forum posts (`posts/`).

#### Q19: How are diagnostic image files saved in the cloud?
Uploaded to `/scans/{userId}/{scanId}.jpg` in Firebase Storage.

#### Q20: Are Firebase rules secure?
Yes, the security rules restrict read and write permissions to the authenticated user ID.

---

### 5. Troubleshooting & Debugging

#### Q21: Why is my emulator reported as offline?
The ADB connection has timed out. Restart the ADB server: `adb kill-server` and `adb start-server`.

#### Q22: Why does the app fail on the camera screen?
The device camera permission is not enabled or missing from the OS configuration file (e.g. `AndroidManifest.xml`).

#### Q23: Why do I get a port conflict error on port 8080?
Another program is using port `8080`. Stop the active process or start FastAPI using a different port parameter.

#### Q24: What is the Android emulator backend IP?
The emulator communicates with the developer host machine using loopback gateway `10.0.2.2`.

#### Q25: How do I clean local compiler caches?
Run `flutter clean` in the `frontend/` directory.

---

### 6. Development & Contributing

#### Q26: How do I test the application code?
Run `flutter test` inside the `frontend/` folder.

#### Q27: How do I contribute features?
Create a feature branch, implement your feature following the clean architecture guidelines, and submit a Pull Request.

#### Q28: How do I format Dart files?
Run `flutter format .` inside `frontend/`.

#### Q29: What is the commit message style?
Use Conventional Commits: `<type>(<scope>): <description>`.

#### Q30: How do I report bugs?
Open an issue on the repository, detailing the steps to reproduce, console logs, and your target environment.
