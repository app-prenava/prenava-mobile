import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../providers/banner_providers.dart';
import '../widgets/user_header.dart';
import '../widgets/menu_grid_item.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/article_carousel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _getGreeting() {
    // Get current time in WIB (UTC+7) - Indonesia Western Time
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final hour = now.hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Future<void> _onRefresh() async {
    await ref.read(bannerNotifierProvider.notifier).refreshBanners();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final profileState = ref.watch(profileNotifierProvider);
    final profilePhoto = profileState.profile?.photoUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: const Color(0xFFFA6978),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Gunakan SingleChildScrollView untuk konten yang bisa melebihi tinggi layar
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bagian dengan background gradien
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/gradien.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            UserHeader(
                              greeting: _getGreeting(),
                              userName: user?.name ?? 'User',
                              avatarUrl: profilePhoto,
                            ),
                            _buildMenuGrid(),
                            _buildPromoSection(),
                          ],
                        ),
                      ),
                      // Bagian dengan background putih (Postingan Populer)
                      _buildArticleSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 6,
          childAspectRatio: 0.85,
          padding: EdgeInsets.zero,
          children: [
            MenuGridItem(
              imagePath: 'assets/images/hidrasi.png',
              label: 'Hidrasi',
              onTap: () => context.push('/hydration'),
            ),
            MenuGridItem(
              imagePath: 'assets/images/tips.png',
              label: 'Tips',
              onTap: () => context.push('/tips'),
            ),
            MenuGridItem(
              imagePath: 'assets/images/kalkulator hpl.png',
              label: 'Kalkulator HPL',
              onTap: () => context.push('/pregnancy-calculator'),
            ),
            MenuGridItem(
              imagePath: 'assets/images/kunjungan.png',
              label: 'Kunjungan',
              onTap: () => context.push('/kunjungan'),
            ),
            MenuGridItem(
              imagePath: 'assets/images/deteksi depresi.png',
              label: 'Deteksi Depresi',
              onTap: () {},
            ),
            MenuGridItem(
              imagePath: 'assets/images/risiko stunting.png',
              label: 'Risiko Stunting',
              onTap: () {},
            ),
            MenuGridItem(
              imagePath: 'assets/images/anemia.png',
              label: 'Anemia',
              onTap: () {},
            ),
            MenuGridItem(
              imagePath: 'assets/images/calendar.png',
              label: 'Janji Temu',
              onTap: () => context.push('/appointments'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(color: Colors.white, child: const BannerCarousel());
  }

  Widget _buildArticleSection() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Postingan Populer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
      ),
    );
  }
}
