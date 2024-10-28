import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(DigitalLibraryApp());
}

class DigitalLibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: DigitalLibraryScreen(),
    );
  }
}

class DigitalLibraryScreen extends StatefulWidget {
  @override
  _DigitalLibraryScreenState createState() => _DigitalLibraryScreenState();
}

class _DigitalLibraryScreenState extends State<DigitalLibraryScreen> {
  final String _apiKey = 'mbq7bppvukhoustb'; // Replace with your actual API key
  List<dynamic> _items = [];
  List<dynamic> _recommendedBooks = [];
  bool _isLoading = false;

  TextEditingController _searchController = TextEditingController();

  // Fetch recommended books on page load
  Future<void> _fetchRecommendedBooks() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = 'https://api.repo.nypl.org/api/v1/items/search?q=popular&publicDomainOnly=true';
    final response = await http.get(Uri.parse(apiUrl), headers: {'Authorization': 'Token token=$_apiKey'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _recommendedBooks = data['nyplAPI']['response']['items'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load recommended books');
    }
  }

  Future<void> _searchItems(String query) async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = 'https://api.repo.nypl.org/api/v1/items/search?q=$query&publicDomainOnly=true';
    final response = await http.get(Uri.parse(apiUrl), headers: {'Authorization': 'Token token=$_apiKey'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _items = data['nyplAPI']['response']['items'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load search results');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecommendedBooks(); // Fetch recommended books when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/overlay.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Open Library',
                  style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for your books',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchItems(_searchController.text);
                  },
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),

            // Recommended Books or Search Results
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: _items.isEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Books',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _recommendedBooks.length,
                      itemBuilder: (context, index) {
                        final book = _recommendedBooks[index];
                        return ListTile(
                          leading: book['thumbnail'] != null
                              ? Image.network(
                            book['thumbnail'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Icon(Icons.book),
                          title: Text(book['title'] ?? 'No title'),
                          subtitle: Text(book['date'] ?? 'No date available'),
                        );
                      },
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    leading: item['thumbnail'] != null
                        ? Image.network(
                      item['thumbnail'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.book),
                    title: Text(item['title'] ?? 'No title'),
                    subtitle: Text(item['date'] ?? 'No date available'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailScreen(item: item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetailScreen extends StatelessWidget {
  final dynamic item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title'] ?? 'Item Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['thumbnail'] != null)
              Image.network(item['thumbnail'], fit: BoxFit.cover),
            SizedBox(height: 16.0),
            Text(
              item['title'] ?? 'No title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Date: ${item['date'] ?? 'Unknown'}'),
            SizedBox(height: 8.0),
            Text('Type: ${item['type'] ?? 'Unknown'}'),
            SizedBox(height: 16.0),
            Text(item['description'] ?? 'No description available'),
          ],
        ),
      ),
    );
  }
}
