import 'package:flutter/material.dart';
import '../../auth/firestore_service.dart';
import '../../auth/auth_service.dart'; // Import AuthService

class ProfileScreen extends StatefulWidget {

  final Function(String) onProfileUpdated; // Add this line

  ProfileScreen({required this.onProfileUpdated}); // Update constructor

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Password controller
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService(); // AuthService instance

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load profile data when screen initializes
  }

  Future<void> _loadUserProfile() async {
      var profileData = await _firestoreService.getUserProfile();
      if (profileData != null) {
        setState(() {
          _nameController.text = profileData['name'] ?? '';
          _emailController.text = profileData['email'] ?? '';
        });
      }

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    try {
      String updatedName = _nameController.text;
      String updatedEmail = _emailController.text;
      String password = _passwordController.text;

      // Ensure the password is provided for updates
      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password is required for updating profile')),
        );
        return;
      }

      // Update Firestore and Firebase Auth
      await _firestoreService.updateUserProfile(updatedName, updatedEmail, password);

      // Call the callback function to notify HomeScreen of the update
      widget.onProfileUpdated(updatedName); // Add this line

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      // Handle the error (e.g., show an error message)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/dummyWallpaper.jpg'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController, // Password field
              obscureText: true, // Hide password
              decoration: InputDecoration(
                labelText: 'Password (required for updates)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
