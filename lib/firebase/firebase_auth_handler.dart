import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      default:
        return e.code;
    }
  }

  static Future<void> tryLogin(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<void> trySignup(
      String name, String email, String password) async {
    UserCredential credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await credentials.user!.sendEmailVerification();
    await credentials.user!.updateDisplayName(name);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(credentials.user!.uid)
        .set({'name': name, 'email': email, 'points': 0});
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }
}
