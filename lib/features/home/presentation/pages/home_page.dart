import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../community/domain/entities/post.dart';
import '../providers/banner_providers.dart';
import '../providers/popular_posts_providers.dart';
import '../widgets/user_header.dart';
import '../widgets/menu_grid_item.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/lainnya_modal.dart';
import '../widgets/daily_tasks_section.dart';
import '../providers/daily_features_provider.dart';
import '../../../pregnancy/presentation/providers/pregnancy_providers.dart';
import '../../../pregnancy/presentation/widgets/pregnancy_onboarding_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _dailyKey = GlobalKey();
  final GlobalKey _olahragaKey = GlobalKey();
  final GlobalKey _hidrasiKey = GlobalKey();
  final GlobalKey _tipsKey = GlobalKey();
  final GlobalKey _anemiaKey = GlobalKey();
  final GlobalKey _depresiKey = GlobalKey();
  final GlobalKey _udaraKey = GlobalKey();
  final GlobalKey _hplKey = GlobalKey();
  final GlobalKey _lainnyaKey = GlobalKey();

  String _getGreeting() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final hour = now.hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Future<void> _onRefresh() async {
    await ref.read(bannerNotifierProvider.notifier).refreshBanners();
    ref.invalidate(popularPostsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (innerContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final prefs = await SharedPreferences.getInstance();
          final hasSeenTutorial = prefs.getBool('has_seen_tutorial') ?? false;
          if (!hasSeenTutorial) {
            _startTutorial(innerContext);
            await prefs.setBool('has_seen_tutorial', true);
          }
        });

        final authState = ref.watch(authNotifierProvider);
        final user = authState.user;
        final profileState = ref.watch(profileNotifierProvider);
        final profilePhoto = profileState.profile?.photoUrl;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFFA6978),
            elevation: 0,
            toolbarHeight: 0, 
          ),
          body: Container(
            color: const Color(0xFFFA6978),
            child: SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFFFA6978),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/gradien.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Showcase(
                                            key: _headerKey,
                                            description: 'Ini profilmu. Ketuk untuk mengedit atau melihat detail.',
                                            child: GestureDetector(
                                              onTap: () => context.push('/profile'),
                                              child: UserHeader(
                                                greeting: _getGreeting(),
                                                userName: user?.name ?? 'User',
                                                avatarUrl: profilePhoto,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8, right: 4),
                                          child: Row(
                                            children: [
                                              Showcase(
                                                key: _dailyKey,
                                                description: 'Pantau streak dan selesaikan misi harian di sini!',
                                                child: IconButton(
                                                  icon: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      const Icon(Icons.local_fire_department, color: Colors.amber, size: 28),
                                                      ref.watch(dailyProgressProvider).when(
                                                        data: (p) => p.streak > 0 
                                                          ? Positioned(
                                                              right: 0,
                                                              top: 0,
                                                              child: Container(
                                                                padding: const EdgeInsets.all(2),
                                                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                                                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                                                child: Text('${p.streak}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                        loading: () => const SizedBox(),
                                                        error: (_, __) => const SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: _showDailyTasksBottomSheet,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.help_outline, color: Colors.white),
                                                onPressed: () {
                                                  _startTutorial(innerContext);
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    _buildMenuGrid(user?.category ?? 'umum'),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                              _buildPromoSection(),
                              _buildPopularPostsSection(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDailyTasksBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Misi & Progres Harian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: const DailyTasksSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTutorial(BuildContext context) {
    ShowCaseWidget.of(context).startShowCase([
      _headerKey, 
      _dailyKey, 
      _olahragaKey, 
      _hidrasiKey,
      _tipsKey,
      _anemiaKey,
      _depresiKey,
      _udaraKey,
      _hplKey,
      _lainnyaKey
    ]);
  }

  void _handleMenuTap(String route, {bool requiresPregnancy = false}) async {
    if (requiresPregnancy) {
      final pregnancyState = ref.read(pregnancyNotifierProvider);
      if (pregnancyState.isLoading) return;
      
      if (pregnancyState.pregnancy == null) {
        final result = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PregnancyOnboardingSheet(),
        );
        if (result == true && mounted) {
          context.push(route);
        }
        return;
      }
    }
    context.push(route);
  }

  Widget _buildMenuGrid(String category) {
    final List<Widget> items = [];

    items.add(Showcase(
      key: _olahragaKey,
      description: 'Dapatkan rekomendasi olahraga ringan yang aman.',
      child: MenuGridItem(
        imagePath: 'assets/images/kunjungan.png',
        label: 'Rekomendasi Olahraga',
        onTap: () => _handleMenuTap('/rekomendasi-olahraga', requiresPregnancy: true),
      ),
    ));

    items.add(Showcase(
      key: _hidrasiKey,
      description: 'Pantau asupan air harian Anda agar tetap terhidrasi.',
      child: MenuGridItem(
        imagePath: 'assets/images/glass water.png',
        label: 'Rekomendasi Hidrasi',
        onTap: () => context.push('/hydration'),
      ),
    ));

    items.add(Showcase(
      key: _tipsKey,
      description: 'Tips harian untuk kesehatan ibu dan janin.',
      child: MenuGridItem(
        imagePath: 'assets/images/tips.png',
        label: 'Tips & Gizi',
        onTap: () => context.push('/tips'),
      ),
    ));

    if (category == 'ibu_hamil' || category == 'bidan') {
      items.add(Showcase(
        key: _hplKey,
        description: 'Fitur ibu hamil: prediksi hari kelahiran dan informasi trimester.',
        child: MenuGridItem(
          imagePath: 'assets/images/kalkulator hpl.png',
          label: 'Kalkulator HPL',
          onTap: () => context.push('/pregnancy-calculator'),
        ),
      ));
      items.add(MenuGridItem(
        imagePath: 'assets/images/kunjungan.png',
        label: 'Prediksi Persalinan',
        onTap: () {},
      ));
    }

    items.add(Showcase(
      key: _anemiaKey,
      description: 'Ketahui risiko Anemia dengan mengisi form observasi.',
      child: MenuGridItem(
        imagePath: 'assets/images/anemia.png',
        label: 'Prediksi Anemia',
        onTap: () => context.push('/deteksi-anemia'),
      ),
    ));

    items.add(Showcase(
      key: _depresiKey,
      description: 'Deteksi risiko depresi pasca melahirkan melalui analisis foto wajah menggunakan AI.',
      child: MenuGridItem(
        imagePath: 'assets/images/deteksi depresi.png',
        label: 'Prediksi Depresi',
        onTap: () => context.push('/deteksi-depresi'),
      ),
    ));

    items.add(Showcase(
      key: _udaraKey,
      description: 'Cek kualitas udara di sekitar lokasi Bunda untuk memastikan lingkungan yang sehat.',
      child: MenuGridItem(
        imagePath: 'assets/images/risiko stunting.png',
        label: 'Cek Kualitas Udara',
        onTap: () {},
      ),
    ));

    items.add(Showcase(
      key: _lainnyaKey,
      description: 'Buka ini untuk melihat semua fitur tambahan yang tersedia!',
      child: MenuGridItem(
        imagePath: 'assets/images/lainnya.png',
        label: 'Lainnya',
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const LainnyaModal(),
          );
        },
      ),
    ));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          children: items,
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return const BannerCarousel();
  }

  Widget _buildPopularPostsSection() {
    final postsAsync = ref.watch(popularPostsProvider);

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
          postsAsync.when(
            loading: () => const SizedBox(
              height: 130,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFA6978)),
              ),
            ),
            error: (_, __) => const SizedBox(
              height: 130,
              child: Center(
                child: Text(
                  'Gagal memuat postingan',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                ),
              ),
            ),
            data: (posts) {
              if (posts.isEmpty) {
                return const SizedBox(
                  height: 130,
                  child: Center(
                    child: Text(
                      'Belum ada postingan',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _buildPopularPostCard(post);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildPopularPostCard(Post post) {
    String timeAgo = '';
    if (post.createdAt != null) {
      try {
        final date = DateTime.parse(post.createdAt!);
        timeAgo = DateFormat('dd MMM').format(date);
      } catch (_) {
        timeAgo = '';
      }
    }

    return GestureDetector(
      onTap: () => context.push('/community/detail/${post.id}'),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFFCE4EC),
                  backgroundImage: post.user.profileImage != null
                      ? NetworkImage(post.user.profileImage!)
                      : null,
                  child: post.user.profileImage == null
                      ? const Icon(Icons.person, size: 14, color: Color(0xFFFA6978))
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                post.deskripsi,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF555555),
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 14,
                  color: const Color(0xFFFA6978),
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.apresiasi}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${post.komentar}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
