import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  List<Map<String, String>> searchResults = [];

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
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/dummyWallpaper.jpg'),
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
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          Expanded(
            child: searchResults.isEmpty
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
                );
              },
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
}

// Define the ResultCard widget here
class ResultCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final String source;
  final String thumbnailUrl;

  const ResultCard({
    Key? key,
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.thumbnailUrl,
  }) : super(key: key);

  void _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (thumbnailUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                thumbnailUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  source,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: _launchURL,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent, backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('View More'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
