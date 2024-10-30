import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new user in Firebase Auth and save additional user info in Firestore
  Future<User?> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      // Create user in Firebase Authentication
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (cred.user != null) {
        // Save additional user info in Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return cred.user;
      }
    } catch (e) {
      log("Signup error: $e"); // Log error for debugging
    }
    return null;
  }

  // Login user
  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Login error: $e"); // Logs login error
      return null;
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Signout error: $e");
    }
  }

  // Update email and password for user
  Future<void> updateEmailAndPassword(String email, String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
        await user.updatePassword(password);
      }
    } catch (e) {
      log("Update email/password error: $e");
      throw e;
    }
  }
}
