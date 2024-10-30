import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // API keys and Search Engine ID
  static const String _googleApiKey = 'AIzaSyC1cKhEFEJXljaVJD8olLd3bGJAV1zLFwk';
  static const String _youtubeApiKey = 'AIzaSyAoVcOgPUBePXe2cUA6yPjKkV-TVRYqJac';
  static const String _searchEngineId = '76379b7aebfc34e5a';

  // Fetch YouTube results with thumbnails
  Future<List<Map<String, String>>> fetchYouTubeResults(String query) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=5&q=$query&key=$_youtubeApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, String>> results = [];
      for (var item in data['items']) {
        results.add({
          'title': item['snippet']['title'],
          'url': 'https://www.youtube.com/watch?v=${item['id']['videoId']}',
          'thumbnail': item['snippet']['thumbnails']['medium']['url'],
        });
      }
      return results;
    } else {
      throw Exception('Failed to load YouTube results');
    }
  }

  // Fetch Google Search results
  Future<List<Map<String, String>>> fetchGoogleSearchResults(String query) async {
    final url = Uri.parse(
      'https://www.googleapis.com/customsearch/v1?key=$_googleApiKey&cx=$_searchEngineId&q=$query',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, String>> results = [];
      for (var item in data['items']) {
        results.add({
          'title': item['title'],
          'url': item['link'],
        });
      }
      return results;
    } else {
      throw Exception('Failed to load Google search results');
    }
  }
}
