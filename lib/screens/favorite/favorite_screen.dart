import 'package:flutter/material.dart';
import '../../widgets/result_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favoriteResults;
  final Function(Map<String, String>) onFavoriteToggle; // Callback for unfavoriting

  const FavoritesScreen({
    super.key,
    required this.favoriteResults,
    required this.onFavoriteToggle,
  });

  void _confirmRemoveFavorite(BuildContext context, Map<String, String> result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove from Favorites"),
          content: const Text("Are you sure you want to remove this item from your favorites ?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without removing
              },
            ),
            TextButton(
              child: const Text("Remove"),
              onPressed: () {
                onFavoriteToggle(result); // Remove the item from favorites
                Navigator.of(context).pop(); // Close the dialog after removing
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Centered title with reduced padding
          const Padding(
            padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
            child: Center(
              child: Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // Display either favorite items or a placeholder message
          Expanded(
            child: favoriteResults.isEmpty
                ? const Center(child: Text('No favorites yet'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: favoriteResults.length,
              itemBuilder: (context, index) {
                final result = favoriteResults[index];
                return ResultCard(
                  title: result['title'] ?? 'No Title',
                  description: result['description'] ?? 'No Description',
                  url: result['url'] ?? '',
                  source: result['source'] ?? 'Unknown Source',
                  thumbnailUrl: result['thumbnail'] ?? '',
                  isFavorite: true,
                  onFavoriteToggle: () => _confirmRemoveFavorite(context, result), // Show confirmation dialog
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
