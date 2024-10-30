import 'package:flutter/material.dart';

class SearchFilters extends StatelessWidget {
  final bool videosSelected;
  final bool readingSelected;
  final Function(String) onSubmitted;
  final Function(bool) onVideosSelected;
  final Function(bool) onReadingSelected;
  final Function(bool) onBothSelected;

  const SearchFilters({
    super.key,
    required this.videosSelected,
    required this.readingSelected,
    required this.onSubmitted,
    required this.onVideosSelected,
    required this.onReadingSelected,
    required this.onBothSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
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
            onSubmitted: onSubmitted,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text("Videos", style: TextStyle(fontSize: 14)),
              selected: videosSelected,
              onSelected: onVideosSelected,
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text("Reading", style: TextStyle(fontSize: 14)),
              selected: readingSelected,
              onSelected: onReadingSelected,
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 10),
            ChoiceChip(
              label: const Text("Both", style: TextStyle(fontSize: 14)),
              selected: videosSelected && readingSelected,
              onSelected: onBothSelected,
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
      ],
    );
  }
}
