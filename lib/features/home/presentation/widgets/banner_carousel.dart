import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/banner_providers.dart';

class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({super.key});

  @override
  ConsumerState<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<BannerCarousel> {
  int _currentIndex = 0;

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat membuka link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerState = ref.watch(bannerNotifierProvider);

    if (bannerState.isLoading) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFA6978),
          ),
        ),
      );
    }

    if (bannerState.error != null) {
      return SizedBox(
        height: 140,
        child: Center(
          child: Text(
            'Gagal memuat banner',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    if (bannerState.banners.isEmpty) {
      return SizedBox(
        height: 140,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8EC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Color(0xFFFA6978),
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'Belum ada banner',
                  style: TextStyle(
                    color: Color(0xFFFA6978),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerState.banners.length,
          options: CarouselOptions(
            height: 140,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = bannerState.banners[index];
            return GestureDetector(
              onTap: () => _launchUrl(banner.url),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: banner.photo != null && banner.photo!.isNotEmpty
                      ? Image.network(
                          banner.photo!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFFFA6978),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFFFE8EC),
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Color(0xFFFA6978),
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFFFFE8EC),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              color: Color(0xFFFA6978),
                              size: 48,
                            ),
                          ),
                        ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPageIndicator(bannerState.banners.length),
      ],
    );
  }

  Widget _buildPageIndicator(int itemCount) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          itemCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentIndex == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? const Color(0xFFFA6978)
                  : const Color(0xFFFA6978).withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

