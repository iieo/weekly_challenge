import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

String GetFirebaseErrorText(FirebaseAuthException e) {
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

Future TryLogin(String email, String password) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
}

Future TrySignup(String email, String password) async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);
}

Future ForgotPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
