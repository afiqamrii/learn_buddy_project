import 'package:flutter/material.dart';
import 'package:learn_buddy_project/screens/home/profile_screen.dart';
import '../../services/api_service.dart';
import '../../services/date_utils.dart';
import '../../widgets/nav_item.dart';
import '../../widgets/search_filters.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  bool _videosSelected = false;
  bool _readingSelected = false;
  int _selectedIndex = 0;
  bool _hasSearched = false;
  List<Map<String, dynamic>> _results = []; // Updated type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 60.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to the ProfileScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/dummyWallpaper.jpg'),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hi,',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      getGreetingMessage(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                const Icon(Icons.notifications_active, color: Colors.black, size: 28),
              ],
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _hasSearched ? 0 : null,
            bottom: _hasSearched ? null : 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: _hasSearched ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Find Your Study Resource',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hi, Afiq 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No More Curiosity!',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        Text(
                          'Find Anything Related To Your Study Now!',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 30),
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
                ),
              ],
            ),
          ),
          if (_hasSearched)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _results.isNotEmpty
                    ? ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final result = _results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            if (result.containsKey('thumbnail'))
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  result['thumbnail']!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Icon(
                                Icons.article,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    result['title'] ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    result['url'] ?? 'No URL',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueAccent,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Center(child: Text('No results found')),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
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
              label: 'Likes',
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
      ),
    );
  }

  void search(String query) async {
    try {
      List<Map<String, dynamic>> results = []; // Updated type
      if (_videosSelected && !_readingSelected) {
        results = await apiService.fetchYouTubeResults(query);
      } else if (!_videosSelected && _readingSelected) {
        results = await apiService.fetchGoogleSearchResults(query);
      } else if (_videosSelected && _readingSelected) {
        results.addAll(await apiService.fetchYouTubeResults(query));
        results.addAll(await apiService.fetchGoogleSearchResults(query));
      }
      setState(() {
        _results = results;
        _hasSearched = true;
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
}
