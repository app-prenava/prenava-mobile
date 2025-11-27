import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/community_providers.dart';
import '../widgets/post_card.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = const [
    'Terbaru',
    'Parenting',
    'Finansial & Keuangan',
    'Nutrisi',
    'Kesehatan',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(communityNotifierProvider.notifier).setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Search bar
          _buildSearchBar(),

          // Category tabs
          _buildCategoryTabs(communityState),

          // Posts list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(communityNotifierProvider.notifier).refreshPosts(),
              color: const Color(0xFFFA6978),
              child: communityState.isLoading && communityState.posts.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFA6978),
                      ),
                    )
                  : communityState.displayPosts.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: communityState.displayPosts.length,
                          itemBuilder: (context, index) {
                            final post = communityState.displayPosts[index];
                            return PostCard(
                              post: post,
                              onTap: () =>
                                  context.push('/community/detail/${post.id}'),
                              onLike: () => ref
                                  .read(communityNotifierProvider.notifier)
                                  .toggleLike(post.id),
                              onComment: () =>
                                  context.push('/community/detail/${post.id}'),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFA6978),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Komunitas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Berbagi Cerita, Taya Apa Saja',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Cari Postingan',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(CommunityState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = _categories[index];
            final bool active = state.selectedCategory == category;
            return GestureDetector(
              onTap: () => ref
                  .read(communityNotifierProvider.notifier)
                  .setCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFFA6978)
                      : const Color(0xFFFA6978).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    color: active ? Colors.white : const Color(0xFFFA6978),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada postingan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jadilah yang pertama berbagi cerita!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/community/create'),
            icon: const Icon(Icons.add),
            label: const Text('Buat Postingan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
