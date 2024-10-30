import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Retrieve user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> profileSnapshot =
      await _firestore.collection('users').doc(currentUser.uid).get();
      return profileSnapshot.data();
    }
    return null;
  }



  // Update user profile in Firestore and Firebase Auth
  Future<void> updateUserProfile(String name, String email, String password) async {
    User? currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      // Check if the document exists
      DocumentReference userDocRef = _firestore.collection('users').doc(currentUser.uid);
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Update Firestore data
        await userDocRef.update({
          'name': name,
          'email': email,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update email and password in Firebase Auth
        await currentUser.updateEmail(email);
        await currentUser.updatePassword(password);
        await currentUser.updateProfile(displayName: name);
      }
    }
  }
}
