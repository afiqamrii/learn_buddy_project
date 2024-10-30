import 'package:flutter/material.dart';
import '../../auth/firestore_service.dart';
import '../../auth/auth_service.dart'; // Import AuthService
import '../../auth/login_page.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile on initialization
  }

  Future<void> _loadUserProfile() async {
    var profileData = await _firestoreService.getUserProfile();
    if (profileData != null) {
      setState(() {
        _name = profileData['name'] ?? 'No Name';
        _email = profileData['email'] ?? 'No Email';
      });
    }
  }

  void _logout() async {
    await _authService.signOut(); // Log out the user
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Spacer to mimic the AppBar padding
            const Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/dummyWallpaper.jpg'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _name, // Display the name
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _email, // Display the email
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 30),
            buildMenuItem(Icons.settings, 'Update Profile', context),
            buildMenuItem(Icons.help_outline, 'Help & Support', context),
            buildMenuItem(Icons.lock_outline, 'Privacy & Security', context),
            Spacer(),
            buildMenuItem(Icons.logout, 'Logout', context, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, BuildContext context, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isLogout ? Colors.red : Colors.black87,
        ),
      ),
      onTap: () {
        if (isLogout) {
          _showLogoutDialog(context);
        } else {
          // Handle other menu item actions here
        }
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Call logout method
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
