import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

class EmailNotVerifiedException implements Exception {}

class FirebaseAuthHandler {
  static String getFirebaseErrorText(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'Email already exists or is invalid';
      case 'invalid-email':
        return 'Email already exists or is invalid';
      case 'weak-password':
        return 'Password is too weak';
      case 'email-not-verified':
        return 'Email not verified. Please check your inbox.';
      case 'missing-email':
        return 'Please enter an email';
      case 'timeout':
        return 'The request timed out. Please try again.';
      default:
        return e.code;
    }
  }

  static String getEmailAddress() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  static Future<String> getAccessToken() {
    return FirebaseAuth.instance.currentUser!.getIdToken();
  }

  static Future resendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  static bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static Future<bool> isUsersEmailVerified() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    await FirebaseAuth.instance.currentUser!.reload();

    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  //returns if successful
  static Future<void> tryLogin(String email, String password) async {
    UserCredential credentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 15),
            onTimeout: () => throw FirebaseAuthException(code: "timeout"));

    if (credentials.user == null || !credentials.user!.emailVerified) {
      await FirebaseAuth.instance.signOut();
      throw EmailNotVerifiedException();
    }
  }

  static Future<void> trySignup(
      String name, String email, String password) async {
    UserCredential credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 15),
            onTimeout: () => throw FirebaseAuthException(code: "timeout"));

    if (credentials.user == null) {
      return;
    }

    await credentials.user!.sendEmailVerification();
    await credentials.user!.updateDisplayName(name);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(credentials.user!.uid)
        .set({'name': name, 'email': email, 'points': 0});

    await FirebaseAuth.instance.signOut();
  }

  static Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw FirebaseAuthException(code: "timeout"));
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }
}
