import 'package:flutter/material.dart';
import 'article_card.dart';

class ArticleData {
  final String authorName;
  final String authorSubtitle;
  final String? authorAvatar;
  final String content;

  const ArticleData({
    required this.authorName,
    required this.authorSubtitle,
    this.authorAvatar,
    required this.content,
  });
}

class ArticleCarousel extends StatefulWidget {
  final List<ArticleData> articles;

  const ArticleCarousel({
    super.key,
    required this.articles,
  });

  @override
  State<ArticleCarousel> createState() => _ArticleCarouselState();
}

class _ArticleCarouselState extends State<ArticleCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.articles.length,
            itemBuilder: (context, index) {
              final article = widget.articles[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ArticleCard(
                  authorName: article.authorName,
                  authorSubtitle: article.authorSubtitle,
                  authorAvatar: article.authorAvatar,
                  content: article.content,
                  onReadMore: () {},
                  onTap: () {},
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          widget.articles.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? const Color(0xFFFA6978)
                  : const Color(0xFFFA6978).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

