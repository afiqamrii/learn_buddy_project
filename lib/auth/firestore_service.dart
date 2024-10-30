import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserProfile(String name, String email, String password) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Create AuthCredential using email and password for re-authentication
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, // Use the current email of the user
          password: password, // Use the password provided by the user
        );

        // Re-authenticate the user
        await user.reauthenticateWithCredential(credential);

        // Update Firestore with the new data
        await _db.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
        });

        // Update Firebase Authentication profile info
        await user.updateEmail(email);
        await user.updateDisplayName(name);
      }
    } catch (e) {
      print('Error updating user profile: $e');
      throw e; // Handle error as needed
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }
}
