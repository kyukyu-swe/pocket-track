import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  User? user;

  Auth() {
    user = _auth.currentUser;
  }

  bool get isAuth {
    return _auth.currentUser != null;
  }

  Future<void> signup(String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = authResult.user;
      notifyListeners();
    } on PlatformException catch (err) {
      String? message = 'An error occurred!';
      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      var authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = authResult.user;
      notifyListeners();
    } on PlatformException catch (err) {
      String? message = 'An error occurred!';
      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      var authResult = await _auth.sendPasswordResetEmail(
        email: email,
      );

      notifyListeners();
    } on PlatformException catch (err) {
      String? message = 'An error occurred!';
      if (err.message != null) {
        message = err.message;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _auth.signOut();
    notifyListeners();
  }
}
