import 'package:flutter/material.dart';
import 'wave_painter.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;

  const OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;

        return Column(
          children: [
            _buildTopSection(screenWidth, screenHeight),
            _buildBottomSection(screenHeight, screenWidth),
          ],
        );
      },
    );
  }

  Widget _buildTopSection(double screenWidth, double screenHeight) {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFC7286),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Stack(
          children: [
            _buildWaveBackground(screenWidth),
            _buildTopContent(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveBackground(double screenWidth) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        size: Size(screenWidth, 100),
        painter: WavePainter(),
      ),
    );
  }

  Widget _buildTopContent(double screenWidth, double screenHeight) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.02,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            data.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(double screenHeight, double screenWidth) {
    return Expanded(
      flex: 6,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, contentConstraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMainImage(contentConstraints),
                SizedBox(height: contentConstraints.maxHeight * 0.04),
                _buildDescription(contentConstraints),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainImage(BoxConstraints contentConstraints) {
    return Flexible(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: contentConstraints.maxWidth * 0.1,
        ),
        child: Image.asset(
          data.image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDescription(BoxConstraints contentConstraints) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: contentConstraints.maxWidth * 0.1,
        ),
        child: Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFFC7286),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}


