import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// To regenerate this file, run `flutterfire configure`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace these placeholder values with your actual Firebase config.
  // Run `flutterfire configure` to generate real values.

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAEHoDHYr_1Lj2jrnWJulEmQNqmXKnZMFs',
    appId: '1:307749770376:android:236c1f7ae6ff3eb5ae7b3d',
    messagingSenderId: '307749770376',
    projectId: 'krishios-c9e32',
    storageBucket: 'krishios-c9e32.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-d1ZnDGPi6ohNxrUWnSWjnWUEAbjzVyE',
    appId: '1:307749770376:ios:ae60ae049645423fae7b3d',
    messagingSenderId: '307749770376',
    projectId: 'krishios-c9e32',
    storageBucket: 'krishios-c9e32.firebasestorage.app',
    iosBundleId: 'com.krishios.krishios',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-d1ZnDGPi6ohNxrUWnSWjnWUEAbjzVyE',
    appId: '1:307749770376:ios:ae60ae049645423fae7b3d',
    messagingSenderId: '307749770376',
    projectId: 'krishios-c9e32',
    storageBucket: 'krishios-c9e32.firebasestorage.app',
    iosBundleId: 'com.krishios.krishios',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    authDomain: 'YOUR_AUTH_DOMAIN',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );
}
