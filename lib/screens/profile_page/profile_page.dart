import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
                'Afiq',
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
                'afiq@example.com',
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
                // Perform logout action hereimport 'package:flutter/material.dart';
                //
                // class ProfilePage extends StatelessWidget {
                //   @override
                //   Widget build(BuildContext context) {
                //     return Scaffold(
                //       backgroundColor: Colors.grey[100],
                //       body: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const SizedBox(height: 40), // Spacer to mimic the AppBar padding
                //             const Center(
                //               child: Text(
                //                 'Profile',
                //                 style: TextStyle(
                //                   color: Colors.black,
                //                   fontSize: 24,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(height: 30),
                //             const Center(
                //               child: CircleAvatar(
                //                 radius: 50,
                //                 backgroundImage: AssetImage('assets/images/dummyWallpaper.jpg'),
                //               ),
                //             ),
                //             const SizedBox(height: 16),
                //             Center(
                //               child: Text(
                //                 'Afiq',
                //                 style: TextStyle(
                //                   fontSize: 22,
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.black87,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(height: 8),
                //             Center(
                //               child: Text(
                //                 'afiq@example.com',
                //                 style: TextStyle(
                //                   fontSize: 16,
                //                   color: Colors.grey[600],
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(height: 30),
                //             buildMenuItem(Icons.settings, 'Update Profile', context),
                //             buildMenuItem(Icons.help_outline, 'Help & Support', context),
                //             buildMenuItem(Icons.lock_outline, 'Privacy & Security', context),
                //             Spacer(),
                //             buildMenuItem(Icons.logout, 'Logout', context, isLogout: true),
                //           ],
                //         ),
                //       ),
                //     );
                //   }
                //
                //   Widget buildMenuItem(IconData icon, String title, BuildContext context, {bool isLogout = false}) {
                //     return ListTile(
                //       leading: Icon(
                //         icon,
                //         color: isLogout ? Colors.red : Colors.grey[700],
                //       ),
                //       title: Text(
                //         title,
                //         style: TextStyle(
                //           fontSize: 16,
                //           color: isLogout ? Colors.red : Colors.black87,
                //         ),
                //       ),
                //       onTap: () {
                //         if (isLogout) {
                //           _showLogoutDialog(context);
                //         } else {
                //           // Handle other menu item actions here
                //         }
                //       },
                //     );
                //   }
                //
                //   void _showLogoutDialog(BuildContext context) {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return AlertDialog(
                //           title: Text('Logout'),
                //           content: Text('Are you sure you want to log out?'),
                //           actions: <Widget>[
                //             TextButton(
                //               onPressed: () => Navigator.of(context).pop(),
                //               child: Text('Cancel'),
                //             ),
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop(); // Close the dialog
                //                 // Perform logout action here
                //               },
                //               child: Text('Logout'),
                //             ),
                //           ],
                //         );
                //       },
                //     );
                //   }
                // }
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
