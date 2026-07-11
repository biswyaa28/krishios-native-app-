import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      throw UnsupportedError('Google Sign-In is not available on Desktop platforms yet. Please use email/password sign-in or guest bypass.');
    }
    final google = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await google.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _createUserProfile(userCredential.user!);
    return userCredential.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> signUpWithEmail(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user!.updateDisplayName(name);
    await _createUserProfile(userCredential.user!, name: name);
    return userCredential.user;
  }

  Future<void> signOut() async {
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) {
      try { await GoogleSignIn().signOut(); } catch (_) {}
    }
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> _createUserProfile(User user, {String? name}) async {
    final doc = _firestore.collection('users').doc(user.uid);
    final existing = await doc.get();
    if (!existing.exists) {
      await doc.set({
        'name': name ?? user.displayName ?? 'User',
        'email': user.email,
        'role': 'farmer',
        'avatarUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
