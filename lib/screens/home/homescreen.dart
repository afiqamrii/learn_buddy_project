import 'package:flutter/material.dart';
import 'package:learn_buddy_project/screens/home/profile_screen.dart';
import 'package:learn_buddy_project/screens/profile_page/profile_page.dart';
import '../../services/api_service.dart';
import '../../services/date_utils.dart';
import '../../auth/firestore_service.dart'; // Import FirestoreService
import '../../auth/auth_service.dart'; // Import AuthService
import '../../widgets/nav_item.dart';
import '../../widgets/result_card.dart';
import '../../widgets/search_filters.dart';
import '../favorite/favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final FirestoreService firestoreService = FirestoreService(); // FirestoreService instance
  final AuthService authService = AuthService(); // AuthService instance
  bool _videosSelected = false;
  bool _readingSelected = false;
  int _selectedIndex = 0;
  List<Map<String, String>> searchResults = [];
  List<Map<String, String>> favoriteResults = [];
  String? userName; // Variable to hold user's name

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the screen initializes
  }

  Future<void> _loadUserData() async {
    var userData = await firestoreService.getUserProfile(); // Fetch user profile
    if (userData != null) {
      setState(() {
        userName = userData['name']; // Assuming 'name' is a field in Firestore
      });
    }
  }

  void search(String query) async {
    try {
      List<Map<String, String>> results = [];
      if (_videosSelected && !_readingSelected) {
        results = await apiService.fetchYouTubeResults(query);
      } else if (!_videosSelected && _readingSelected) {
        results = await apiService.fetchGoogleSearchResults(query);
      } else if (_videosSelected && _readingSelected) {
        results = await apiService.fetchYouTubeResults(query) +
            await apiService.fetchGoogleSearchResults(query);
      }
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print('Error fetching results: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleFavorite(Map<String, String> result) {
    setState(() {
      if (favoriteResults.contains(result)) {
        favoriteResults.remove(result);
      } else {
        favoriteResults.add(result);
      }
    });
  }

  Widget buildSearchResults() {
    return searchResults.isEmpty
        ? Center(child: Text('No results found'))
        : ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        return ResultCard(
          title: result['title'] ?? 'No Title',
          description: result['description'] ?? 'No Description',
          url: result['url'] ?? '',
          source: result['source'] ?? 'Unknown Source',
          thumbnailUrl: result['thumbnail'] ?? '',
          isFavorite: favoriteResults.contains(result),
          onFavoriteToggle: () => toggleFavorite(result),
        );
      },
    );
  }

  Widget buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 60.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        onProfileUpdated: (updatedName) {
                          setState(() {
                            userName = updatedName; // Update the userName in HomeScreen
                          });
                        },
                      ),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/dummyWallpaper.jpg'),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    userName != null ? getGreetingMessage() : 'Loading...', // Correct usage
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Spacer(),
              const Icon(Icons.notifications_active, color: Colors.black, size: 24),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Find Your Study Resource',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                userName != null ? 'Hi, $userName 👋' : 'Loading...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'No More Curiosity!',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              Text(
                'Find Anything Related To Your Study Now!',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              SearchFilters(
                videosSelected: _videosSelected,
                readingSelected: _readingSelected,
                onSubmitted: (query) {
                  search(query);
                },
                onVideosSelected: (selected) {
                  setState(() {
                    _videosSelected = selected;
                  });
                },
                onReadingSelected: (selected) {
                  setState(() {
                    _readingSelected = selected;
                  });
                },
                onBothSelected: (selected) {
                  setState(() {
                    _videosSelected = selected;
                    _readingSelected = selected;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: buildSearchResults(),
        ),
      ],
    );
  }

  Widget buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            iconPath: 'assets/icons/home.png',
            selectedIconPath: 'assets/icons/home.png',
            label: 'Home',
            index: 0,
            isSelected: _selectedIndex == 0,
            onTap: () => _onItemTapped(0),
          ),
          NavItem(
            iconPath: 'assets/icons/love.png',
            selectedIconPath: 'assets/icons/love.png',
            label: 'Favorites',
            index: 1,
            isSelected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1),
          ),
          NavItem(
            iconPath: 'assets/icons/profile.png',
            selectedIconPath: 'assets/icons/profile.png',
            label: 'Profile',
            index: 2,
            isSelected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _selectedIndex == 0
          ? buildHomeContent()
          : (_selectedIndex == 1
          ? FavoritesScreen(
        favoriteResults: favoriteResults,
        onFavoriteToggle: toggleFavorite,
      )
          : ProfilePage()), // Show ProfileScreen for profile tab
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}