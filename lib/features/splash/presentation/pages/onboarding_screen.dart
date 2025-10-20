import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      image: 'assets/images/prenava_logo.png',
      title: 'Selamat datang\nMoms !!',
      description:
          'Nuri adalah aplikasi cerdas\nuntuk mendampingi ibu hamil\ndalam memantau kesehatan dan\nperkembangan kehamilan.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding2.png',
      title: 'Selamat datang\nMoms !!',
      description:
          'Jaga kesehatan si kecil dengan\npendampingan cerdas selama\nkehamilan',
    ),
    OnboardingData(
      image: 'assets/images/onboarding3.png',
      title: 'Selamat datang\nMoms !!',
      description:
          'Temani setiap langkah\nkehamilan Anda dengan aplikasi\nNuri',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefsHelper = SharedPrefsHelper();
    await prefsHelper.setOnboardingComplete(true);

    if (!mounted) return;
    context.go('/login');
  }

  void _handleButtonPress() {
    if (_currentPage == _pages.length - 1) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardingPage(data: _pages[index]);
              },
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPageIndicators(screenWidth),
              const SizedBox(height: 30),
              _buildStartButton(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicators(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          width: screenWidth * 0.03,
          height: screenWidth * 0.03,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? const Color(0xFFFC7286)
                : const Color(0xFFFFB3C6),
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleButtonPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFC7286),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'MULAI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

