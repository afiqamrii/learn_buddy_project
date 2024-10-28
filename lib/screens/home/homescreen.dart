import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Default selected index is 1 for Home

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background color
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/avatar.jpg'), // Replace with actual image asset
                ),
                Icon(Icons.settings, color: Colors.grey[700], size: 30),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Find Your Study Resource',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hi, Afiq 👋', // Replace with dynamic user data if available
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No More Curiosity!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Text(
                      'Find Anything Related To Your Study Now!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // shadow position
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for topics...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (query) {
                          // Add search query functionality
                          print('User searched: $query');
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Icon(
                      Icons.filter_list,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // Home icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), // Favorite icon
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), // Settings icon
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent, // Highlight color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        showUnselectedLabels: false, // Only show labels on selected items
        backgroundColor: Colors.white, // Navbar background
        elevation: 10, // Elevation for modern look
        onTap: _onItemTapped,
      ),
    );
  }
}
