import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prenava_mobile/shared/widgets/widgets.dart';
import 'package:prenava_mobile/shared/widgets/feature_guide_page.dart';
import 'package:prenava_mobile/shared/providers/guide_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/community_providers.dart';
import '../widgets/post_card.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  static const List<Map<String, String>> _categoryFilters = [
    {'key': 'semua', 'label': 'Semua'},
    {'key': 'keluhan_gejala', 'label': 'Keluhan & Gejala'},
    {'key': 'nutrisi', 'label': 'Nutrisi & Gizi'},
    {'key': 'persalinan', 'label': 'Persiapan Persalinan'},
    {'key': 'mitos_fakta', 'label': 'Mitos & Fakta'},
    {'key': 'parenting', 'label': 'Parenting'},
  ];

  bool _hasSeenGuide = true;
  bool _guideChecked = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _checkGuide();
  }

  Future<void> _checkGuide() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('has_seen_community_guide') ?? false;
    if (mounted) {
      setState(() {
        _hasSeenGuide = seen;
        _guideChecked = true;
      });
      if (!seen) {
        guideVisibleNotifier.value = true;
      }
    }
  }

  Future<void> _dismissGuide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_community_guide', true);
    if (mounted) {
      guideVisibleNotifier.value = false;
      setState(() => _hasSeenGuide = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(communityNotifierProvider.notifier).loadPosts(loadMore: true);
    }
  }

  void _onSearchChanged(String query) {
    ref.read(communityNotifierProvider.notifier).setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    if (_guideChecked && !_hasSeenGuide) {
      return FeatureGuidePage(
        title: 'Komunitas Prenava',
        subtitle: 'Forum konsultasi & tanya jawab kehamilan',
        accentColor: const Color(0xFFFA6978),
        onDone: _dismissGuide,
        items: const [
          GuideItem(
            title: 'Tanya Bidan & Komunitas',
            description: 'Tanyakan keluhan fisik atau kebingungan seputar kehamilan Anda.',
            icon: Icons.chat_bubble_outline,
          ),
          GuideItem(
            title: 'Validasi Klinis Bidan',
            description: 'Bidan terdaftar akan memvalidasi jawaban dan menyematkan edukasi medis.',
            icon: Icons.verified_user_outlined,
          ),
          GuideItem(
            title: 'Tanya sebagai Bunda Anonim',
            description: 'Keluhan sensitif dapat ditanyakan secara anonim tanpa menampilkan profil.',
            icon: Icons.visibility_off_outlined,
          ),
          GuideItem(
            title: 'Pantau Pertanyaan Saya',
            description: 'Gunakan tab Pertanyaan Saya untuk melihat status respon bidan.',
            icon: Icons.assignment_outlined,
          ),
        ],
      );
    }

    final communityState = ref.watch(communityNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.user?.id;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/create'),
        backgroundColor: const Color(0xFFFA6978),
        elevation: 2,
        icon: const Icon(Icons.edit_note, color: Colors.white),
        label: const Text(
          'Tanya di Forum',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Main Tabs: "Semua Diskusi" & "Pertanyaan Saya"
          _buildMainSegmentTabs(communityState),

          // Search bar
          _buildSearchBar(),

          // Category Chips
          _buildCategoryChips(communityState),

          const SizedBox(height: 8),

          // Posts List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(communityNotifierProvider.notifier).refreshPosts(),
              color: const Color(0xFFFA6978),
              child: communityState.isLoading && communityState.posts.isEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: 4,
                      itemBuilder: (context, index) => const PostSkeleton(),
                    )
                  : communityState.displayPosts.isEmpty
                      ? _buildEmptyState(communityState)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 4, bottom: 80),
                          itemCount: communityState.displayPosts.length +
                              (communityState.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == communityState.displayPosts.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFFA6978),
                                  ),
                                ),
                              );
                            }

                            final post = communityState.displayPosts[index];
                            final isMine = currentUserId != null && post.user.id == currentUserId;
                            return PostCard(
                              post: post,
                              onTap: () =>
                                  context.push('/community/detail/${post.id}'),
                              onLike: () => ref
                                  .read(communityNotifierProvider.notifier)
                                  .optimisticToggleLike(post.id),
                              onComment: () =>
                                  context.push('/community/detail/${post.id}'),
                              isMine: isMine,
                              onDelete: isMine
                                  ? () => _confirmDeletePost(context, post.id)
                                  : null,
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeletePost(BuildContext context, int postId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus Postingan'),
          content: const Text(
            'Apakah Bunda yakin ingin menghapus postingan ini? '
            'Komentar dan tanggapan juga akan terhapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Color(0xFFFA6978)),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    final notifier = ref.read(communityNotifierProvider.notifier);
    final success = await notifier.deletePost(postId);

    if (!mounted) return;

    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Postingan berhasil dihapus' : 'Gagal menghapus postingan',
        ),
        backgroundColor: success ? const Color(0xFFFA6978) : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFA6978),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forum Ibu Hamil',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Konsultasi keluhan kehamilan & validasi medis bersama Bidan',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSegmentTabs(CommunityState state) {
    final isAll = state.activeTab == 'all';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  ref.read(communityNotifierProvider.notifier).setActiveTab('all'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isAll ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isAll
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Semua Diskusi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isAll ? FontWeight.bold : FontWeight.w500,
                    color: isAll ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => ref
                  .read(communityNotifierProvider.notifier)
                  .setActiveTab('my_posts'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !isAll ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: !isAll
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'Pertanyaan Saya',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: !isAll ? FontWeight.bold : FontWeight.w500,
                    color: !isAll ? const Color(0xFFFA6978) : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(color: Colors.black87, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Cari pertanyaan atau gejala...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFA6978)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(CommunityState state) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categoryFilters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final cat = _categoryFilters[index];
          final bool active = state.selectedCategory == cat['key'];
          return GestureDetector(
            onTap: () => ref
                .read(communityNotifierProvider.notifier)
                .setCategory(cat['key']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFFA6978) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? const Color(0xFFFA6978) : Colors.grey[300]!,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                cat['label']!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  color: active ? Colors.white : Colors.grey[800],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(CommunityState state) {
    final isMyPosts = state.activeTab == 'my_posts';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMyPosts ? Icons.assignment_outlined : Icons.forum_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 14),
            Text(
              isMyPosts
                  ? 'Belum Ada Pertanyaan Saya'
                  : 'Belum Ada Diskusi Ditemukan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isMyPosts
                  ? 'Bunda belum pernah mengajukan pertanyaan di forum. Ketuk tombol di bawah untuk menanyakan keluhan ke Bidan.'
                  : 'Gunakan kata kunci atau kategori lain untuk melihat diskusi sesama Bunda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey[500],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () => context.push('/community/create'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Buat Pertanyaan Sekarang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA6978),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
