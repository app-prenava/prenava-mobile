import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/sport_recommendation.dart';

class SportDetailPage extends StatelessWidget {
  final SportRecommendation sport;

  const SportDetailPage({super.key, required this.sport});

  Future<void> _launchVideoUrl(BuildContext context) async {
    final url = sport.videoLink;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video tidak tersedia')),
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka video')),
        );
      }
    }
  }

  String? _getYoutubeThumbnail(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      String? videoId;
      if (uri.host.contains('youtube.com')) {
        videoId = uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }
      if (videoId != null && videoId.isNotEmpty) {
        return 'https://img.youtube.com/vi/$videoId/0.jpg';
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final activity = sport.activity;
    final formattedTitle = activity
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
    
    final longText = sport.longText ?? 'Belum ada deskripsi mendetail untuk olahraga ini.';
    final youtubeThumbnail = _getYoutubeThumbnail(sport.videoLink);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFA6978),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Olahraga',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Video/Image Placeholder
              GestureDetector(
                onTap: () => _launchVideoUrl(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildImage(
                        (sport.picture1 != null && sport.picture1 != 'data not found') 
                            ? sport.picture1 
                            : youtubeThumbnail, 
                        height: 220, 
                        width: double.infinity
                      ),
                      Container(
                        height: 220,
                        width: double.infinity,
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 70,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Putar Video Latihan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Small Images Row
              Row(
                children: [
                  Expanded(child: _buildSmallImage(sport.picture1)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSmallImage(sport.picture2)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSmallImage(sport.picture3)),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Title
              Text(
                formattedTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              
              // Description
              Text(
                longText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallImage(String? url) {
    if (url == 'data not found') url = null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildImage(url, height: 80, width: double.infinity),
    );
  }

  Widget _buildImage(String? url, {required double height, required double width}) {
    if (url != null && url.isNotEmpty && url != 'data not found') {
      return Image.network(
        url,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(height: height, width: width);
        },
      );
    }
    return _buildPlaceholder(height: height, width: width);
  }

  Widget _buildPlaceholder({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Color(0xFFBDBDBD),
          size: 30,
        ),
      ),
    );
  }
}
