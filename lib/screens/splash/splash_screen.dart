import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF111122)],
              ),
            ),
          ),
          // Logo positioned at top left with custom padding and size
          Positioned(
            top: 45, // Adjust top padding as needed
            left: 0, // Adjust left padding as needed
            child: SvgPicture.asset(
              'assets/logo/lb_logo.svg',
              width: 110, // Adjust width for resizing
              height: 110, // Adjust height for resizing
            ),
          ),
          // Content with SafeArea
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 14),
                  // Main text
                  AnimatedOpacity(
                    opacity: isVisible ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.4,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Struggling to keep up ?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                          ),
                          TextSpan(
                            text: 'Discover learning content ',
                            style: const TextStyle(

                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(text: 'for you, '),
                          TextSpan(
                            text: 'right here.',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber, // Highlight color for "right here"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Subtitle text
                  Text(
                    'Hedon brings the resources you need at a price you can afford.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Get Started button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      backgroundColor: Colors.amber, // Button color
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
