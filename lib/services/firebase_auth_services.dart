import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/features/toast.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<User?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await analytics.logEvent(
        name: 'sign_up',
        parameters: {
          'email' : email,
          'timestamp' : DateTime.now().toIso8601String(),
        }
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showCustomToast(context, "The email address is invalid", "");
      }

      if (e.code == 'email-already-in-use') {
        showCustomToast(context, "The account already exists", "");
      } else if (e.code == 'weak-password') {
        showCustomToast(context, "The password provided is too week", "");
      } else {
        showCustomToast(context, "Some error occured", "${e.code}");
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await analytics.logEvent(name: 'Account_sign_in', parameters: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        showCustomToast(context, "The email address is invalid", "");
      } else if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        showCustomToast(context, "Invalid email or password", "");
      } else if (e.code == 'user-disabled') {
        showCustomToast(context, "The user account has been disabled", "");
      } else {
        showCustomToast(context, "Some error occured", "${e.code}");
      }
    }
    return null;
  }
}
