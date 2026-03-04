import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../community/domain/entities/post.dart';
import '../providers/banner_providers.dart';
import '../providers/popular_posts_providers.dart';
import '../widgets/user_header.dart';
import '../widgets/menu_grid_item.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/lainnya_modal.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final profileState = ref.watch(profileNotifierProvider);
    final profilePhoto = profileState.profile?.photoUrl;

    return Scaffold(
      backgroundColor: Colors.white,
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
                                UserHeader(
                                  greeting: _getGreeting(),
                                  userName: user?.name ?? 'User',
                                  avatarUrl: profilePhoto,
                                ),
                                _buildMenuGrid(),
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
  }

  Widget _buildMenuGrid() {
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
          ],
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
      onTap: () => context.push('/community/${post.id}'),
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
            // Author row
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
            // Content
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
            // Likes row
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
