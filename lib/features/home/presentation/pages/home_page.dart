import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/user_header.dart';
import '../widgets/menu_grid_item.dart';
import '../widgets/promo_card.dart';
import '../widgets/article_card.dart';

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
            icon: Icons.fitness_center,
            label: 'Rekomendasi Olahraga',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.restaurant,
            label: 'Rekomendasi Makanan',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.medical_services_outlined,
            label: 'Prediksi Anemia',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.pregnant_woman,
            label: 'Prediksi Depresi',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.calculate_outlined,
            label: 'Kalkulator HPL',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.healing,
            label: 'Prediksi Persalinan',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.air,
            label: 'Cek Kualitas Udara',
            onTap: () {},
          ),
          MenuGridItem(
            icon: Icons.grid_view,
            label: 'Lainnya',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
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
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              PromoCard(
                title: 'Promo Prenava',
                onTap: () {},
              ),
              PromoCard(
                title: 'Diskon Spesial',
                backgroundColor: const Color(0xFFFFD6E0),
                onTap: () {},
              ),
              PromoCard(
                title: 'Gratis Ongkir',
                backgroundColor: const Color(0xFFFFEBF0),
                onTap: () {},
              ),
            ],
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ArticleCard(
                authorName: 'Arya Kamal',
                authorSubtitle: 'Dipost oleh Arya Kecw • 19 Oct',
                content:
                    'Pentingnya nutrisi makanan bagi ibu hamil sangat penting untuk pertumbuhan janin. Nutrisi yang cukup membantu tubuh tumbuh sehat, menjaga energi, dan meningkatkan penyakit. Dengan makan makanan sehat, fokus, dan bahaya setiap hari loh!. dkk.',
                onReadMore: () {},
                onTap: () {},
              ),
              ArticleCard(
                authorName: 'Arya Kamal',
                authorSubtitle: 'Dipost oleh Arya Kecw • 18 Oct',
                content:
                    'Tips olahraga ringan untuk ibu hamil trimester pertama. Olahraga yang tepat dapat membantu menjaga kesehatan ibu dan janin. Pastikan konsultasi dengan dokter sebelum memulai.',
                onReadMore: () {},
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

