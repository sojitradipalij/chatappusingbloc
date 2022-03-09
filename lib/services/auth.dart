import 'package:bloc_chatapp/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    User? user;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;

      return user!;
    } on FirebaseAuthException catch (e) {
      print("error : $e");
      switch (e.code) {
        case 'invalid-email':
          {
            showToast("Email is not valid");
            return null;
          }
        case 'user-disabled':
          {
            showToast('Account is not active');
            return null;
          }
        case 'user-not-found':
          {
            showToast('No user found');
            return null;
          }
        case 'wrong-password':
          {
            showToast('wrong password');
            return null;
          }
        default:
          {
            showToast('Unexpected error!');
            return null;
          }
      }
    }
    // catch (e) {
    //   print("-------------------");
    //   print(e.toString());
    //   return null;
    // }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    User? user;
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      return user;
    }  on FirebaseAuthException catch (e) {
      print("error : $e");
      print("error : ${e.code}");
      switch (e.code) {
        case 'email-already-in-use':
          {
            showToast("The email address is already in use by another account");
            return null;
          }
        default:
          {
            showToast('Unexpected error!');
            return null;
          }
      }
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
