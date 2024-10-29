import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_buddy_project/screens/home/homescreen.dart';
import 'package:learn_buddy_project/auth/login_page.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If user is logged in, navigate to HomeScreen
        if (snapshot.hasData) {
          return HomeScreen();
        }
        // Else show LoginPage
        return const LoginPage();
      },
    );
  }
}
