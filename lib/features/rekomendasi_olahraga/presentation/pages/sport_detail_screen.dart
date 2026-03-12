import 'package:flutter/material.dart';
import '../../data/models/sport_recommendation_response.dart';

class SportDetailScreen extends StatelessWidget {
  final SportActivity activity;

  const SportDetailScreen({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Olahraga'),
        backgroundColor: const Color(0xFFC75166),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image / Video Placeholder
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    activity.picture1,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
                  if (activity.videoLink != 'data not found' && activity.videoLink.isNotEmpty)
                    Center(
                      child: Icon(Icons.play_circle_fill, size: 60, color: Colors.white.withOpacity(0.8)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Additional Image Thumbnails (if available)
            if (activity.picture2 != 'data not found' || activity.picture3 != 'data not found')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    if (activity.picture1 != 'data not found')
                      _buildThumbnail(activity.picture1),
                    if (activity.picture2 != 'data not found')
                      _buildThumbnail(activity.picture2),
                    if (activity.picture3 != 'data not found')
                      _buildThumbnail(activity.picture3),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                activity.activity,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Long Text Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                activity.longText == 'data not found' ? 'Deskripsi belum tersedia.' : activity.longText,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
