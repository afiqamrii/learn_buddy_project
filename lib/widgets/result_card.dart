import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
