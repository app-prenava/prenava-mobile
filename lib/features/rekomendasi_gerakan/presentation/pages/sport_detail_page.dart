import 'package:flutter/material.dart';
import 'package:prenava_mobile/core/utils/image_url_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../domain/entities/sport_recommendation.dart';

class SportDetailPage extends StatelessWidget {
  final SportRecommendation sport;

  const SportDetailPage({super.key, required this.sport});

  void _openVideoPlayer(BuildContext context, String title) {
    final url = sport.videoLink;

    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video tidak tersedia')),
      );
      return;
    }

    final videoId = _getYoutubeVideoId(url);

    if (videoId == null || videoId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format video tidak valid')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SportVideoPlayerPage(
          videoId: videoId,
          title: title,
        ),
      ),
    );
  }

  String? _getYoutubeVideoId(String? url) {
    if (url == null || url.isEmpty) return null;

    final convertedId = YoutubePlayer.convertUrlToId(url);
    if (convertedId != null && convertedId.isNotEmpty) {
      return convertedId;
    }

    try {
      final uri = Uri.parse(url);

      if (uri.host.contains('youtube.com')) {
        if (uri.queryParameters.containsKey('v')) {
          return uri.queryParameters['v'];
        }

        if (uri.pathSegments.contains('live') && uri.pathSegments.isNotEmpty) {
          return uri.pathSegments.last;
        }

        if (uri.pathSegments.contains('shorts') && uri.pathSegments.isNotEmpty) {
          return uri.pathSegments.last;
        }

        if (uri.pathSegments.contains('embed') && uri.pathSegments.isNotEmpty) {
          return uri.pathSegments.last;
        }
      }

      if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.first;
      }
    } catch (_) {}

    return null;
  }

  String? _getYoutubeThumbnail(String? url) {
    final videoId = _getYoutubeVideoId(url);

    if (videoId != null && videoId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }

    return null;
  }

  String? _normalizeLocalImageUrl(String? url) {
    if (url == null || url.isEmpty || url == 'data not found') {
      return null;
    }

    var fixedUrl = ImageUrlHelper.normalizeImageUrl(url);

    if (fixedUrl == null || fixedUrl.isEmpty || fixedUrl == 'data not found') {
      return null;
    }

    // Backend sometimes returns /api/storage/...
    // Image files should be loaded from /storage/..., not /api/storage/...
    fixedUrl = fixedUrl.replaceFirst('/api/storage/', '/storage/');

    // Android Emulator cannot access localhost from inside the emulator.
    fixedUrl = fixedUrl.replaceFirst(
      'http://localhost:8000',
      'http://10.0.2.2:8000',
    );
    fixedUrl = fixedUrl.replaceFirst(
      'https://localhost:8000',
      'http://10.0.2.2:8000',
    );

    return fixedUrl;
  }

  void _showImagePreview(
    BuildContext context,
    String? imageUrl, {
    String? title,
  }) {
    final normalizedUrl = _normalizeLocalImageUrl(imageUrl);

    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gambar tidak tersedia')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 32,
          ),
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(dialogContext).size.height * 0.78,
                maxWidth: MediaQuery.of(dialogContext).size.width,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 48,
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFA6978),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title ?? 'Detail Gambar',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.black,
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Image.network(
                          normalizedUrl,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 260,
                              width: double.infinity,
                              color: const Color(0xFFF5F5F5),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Color(0xFF9E9E9E),
                                  size: 42,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activity = sport.name;

    final formattedTitle = activity
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');

    final longText =
        sport.longText ?? 'Belum ada deskripsi mendetail untuk olahraga ini.';

    final youtubeThumbnail = _getYoutubeThumbnail(sport.videoLink);

    final List<String> availablePictures = [
      sport.picture1,
      sport.picture2,
      sport.picture3,
    ]
        .where(
          (pic) => pic != null && pic.isNotEmpty && pic != 'data not found',
        )
        .cast<String>()
        .toList();

    // Main thumbnail must come from YouTube thumbnail.
    // picture_1, picture_2, picture_3 are shown as the small image gallery below.
    final mainThumbnail = youtubeThumbnail;

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
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildImage(
                      mainThumbnail,
                      height: 220,
                      width: double.infinity,
                      onTap: () => _showImagePreview(
                        context,
                        mainThumbnail,
                        title: 'Thumbnail Video',
                      ),
                    ),
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.black.withValues(alpha: 0.28),
                    ),
                    InkWell(
                      onTap: () => _openVideoPlayer(context, formattedTitle),
                      borderRadius: BorderRadius.circular(999),
                      child: const Column(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (availablePictures.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: availablePictures.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final itemWidth =
                          (screenWidth -
                              40 -
                              (12 * (availablePictures.length - 1))) /
                          availablePictures.length;

                      return SizedBox(
                        width: itemWidth,
                        child: _buildSmallImage(
                          context,
                          availablePictures[index],
                          index,
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),

              Text(
                formattedTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),

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

  Widget _buildSmallImage(
    BuildContext context,
    String? url,
    int index,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildImage(
        url,
        height: 80,
        width: double.infinity,
        onTap: () => _showImagePreview(
          context,
          url,
          title: 'Gambar ${index + 1}',
        ),
      ),
    );
  }

  Widget _buildImage(
    String? url, {
    required double height,
    required double width,
    VoidCallback? onTap,
  }) {
    final normalizedUrl = _normalizeLocalImageUrl(url);

    debugPrint('SportDetail original image URL: $url');
    debugPrint('SportDetail normalized image URL: $normalizedUrl');

    if (normalizedUrl != null && normalizedUrl.isNotEmpty) {
      final image = Image.network(
        normalizedUrl,
        height: height,
        width: width,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            height: height,
            width: width,
            color: const Color(0xFFF5F5F5),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFA6978),
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('SportDetail image error URL: $normalizedUrl');
          debugPrint('SportDetail image error: $error');

          return _buildPlaceholder(height: height, width: width);
        },
      );

      if (onTap == null) return image;

      return GestureDetector(
        onTap: onTap,
        child: image,
      );
    }

    return _buildPlaceholder(height: height, width: width);
  }

  Widget _buildPlaceholder({
    required double height,
    required double width,
  }) {
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

class SportVideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String title;

  const SportVideoPlayerPage({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  State<SportVideoPlayerPage> createState() => _SportVideoPlayerPageState();
}

class _SportVideoPlayerPageState extends State<SportVideoPlayerPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
        forceHD: false,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFFFA6978),
        progressColors: const ProgressBarColors(
          playedColor: Color(0xFFFA6978),
          handleColor: Color(0xFFFA6978),
        ),
      ),
      builder: (context, player) {
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
            title: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
