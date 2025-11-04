import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/user_header.dart';
import '../widgets/menu_grid_item.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/article_carousel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          UserHeader(
            greeting: _getGreeting(),
            userName: user?.name ?? 'User',
            location: 'Bandung',
            onNotificationTap: () {
              // TODO: Navigate to notifications
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildMenuGrid(),
                  const SizedBox(height: 32),
                  _buildPromoSection(),
                  const SizedBox(height: 32),
                  _buildArticleSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 20,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
        children: [
          MenuGridItem(
            imagePath: 'assets/images/yoga-instructor 1.png',
            label: 'Rekomendasi Olahraga',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/vegetables 1.png',
            label: 'Rekomendasi Makanan',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/anemia 1.png',
            label: 'Prediksi Anemia',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/depression 1.png',
            label: 'Prediksi Depresi',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/newborn (1) 1.png',
            label: 'Kalkulator HPL',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/newborn 1.png',
            label: 'Prediksi Persalinan',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/air-quality 1.png',
            label: 'Cek Kualitas Udara',
            onTap: () {},
          ),
          MenuGridItem(
            imagePath: 'assets/images/lainnya.png',
            label: 'Lainnya',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Promo Menarik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
        ),
        SizedBox(height: 16),
        BannerCarousel(),
      ],
    );
  }

  Widget _buildArticleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Postingan Populer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ArticleCarousel(
          articles: const [
            ArticleData(
              authorName: 'Arya Kamal',
              authorSubtitle: 'Dipost oleh Arya Kecw • 19 Oct',
              content:
                  'Pentingnya nutrisi makanan bagi ibu hamil sangat penting untuk pertumbuhan janin. Nutrisi yang cukup membantu tubuh tumbuh sehat, menjaga energi, dan meningkatkan penyakit. Dengan makan makanan sehat, fokus, dan bahaya setiap hari loh!. dkk.',
            ),
            ArticleData(
              authorName: 'Arya Kamal',
              authorSubtitle: 'Dipost oleh Arya Kecw • 18 Oct',
              content:
                  'Tips olahraga ringan untuk ibu hamil trimester pertama. Olahraga yang tepat dapat membantu menjaga kesehatan ibu dan janin. Pastikan konsultasi dengan dokter sebelum memulai.',
            ),
            ArticleData(
              authorName: 'Dr. Sarah',
              authorSubtitle: 'Dipost oleh Dr. Sarah • 17 Oct',
              content:
                  'Persiapan mental menghadapi persalinan sangat penting. Ikuti kelas prenatal, berbicara dengan dokter, dan jangan ragu untuk bertanya tentang proses persalinan.',
            ),
          ],
        ),
      ],
    );
  }
}

