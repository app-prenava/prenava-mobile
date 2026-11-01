import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/community_remote_datasource.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/community_repository.dart';

// Datasource provider
final communityDatasourceProvider = Provider<CommunityRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return CommunityRemoteDatasource(dio);
});

// Repository provider
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final datasource = ref.watch(communityDatasourceProvider);
  return CommunityRepositoryImpl(remoteDatasource: datasource);
});

// ==================== Community State ====================

class CommunityState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<Post> posts;
  final String? error;
  final String searchQuery;
  final String activeTab; // 'all' or 'my_posts'
  final String selectedCategory; // 'semua', 'keluhan_gejala', 'nutrisi', 'persalinan', 'mitos_fakta', 'parenting'
  final int currentPage;
  final int lastPage;
  final int total;

  const CommunityState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.posts = const [],
    this.error,
    this.searchQuery = '',
    this.activeTab = 'all',
    this.selectedCategory = 'semua',
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  const CommunityState.initial()
      : isLoading = false,
        isLoadingMore = false,
        posts = const [],
        error = null,
        searchQuery = '',
        activeTab = 'all',
        selectedCategory = 'semua',
        currentPage = 1,
        lastPage = 1,
        total = 0;

  CommunityState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Post>? posts,
    String? error,
    bool clearError = false,
    String? searchQuery,
    String? activeTab,
    String? selectedCategory,
    int? currentPage,
    int? lastPage,
    int? total,
  }) {
    return CommunityState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      posts: posts ?? this.posts,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      activeTab: activeTab ?? this.activeTab,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }

  bool get hasMore => currentPage < lastPage;

  /// Display posts (already filtered by backend, client fallback filter if needed)
  List<Post> get displayPosts {
    var filtered = posts;

    // Filter by search query if any
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((post) {
        return post.judul.toLowerCase().contains(searchQuery.toLowerCase()) ||
            post.deskripsi.toLowerCase().contains(searchQuery.toLowerCase()) ||
            post.user.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }
}

// ==================== Community Notifier ====================

class CommunityNotifier extends Notifier<CommunityState> {
  @override
  CommunityState build() {
    Future.microtask(() => loadPosts());
    return const CommunityState.initial();
  }

  Future<void> loadPosts({bool loadMore = false}) async {
    if (loadMore && !state.hasMore) return;
    if (loadMore && state.isLoadingMore) return;

    if (loadMore) {
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(isLoading: true, clearError: true, currentPage: 1);
    }

    try {
      final repository = ref.read(communityRepositoryProvider);
      final result = await repository.getAllPosts(
        page: loadMore ? state.currentPage + 1 : 1,
        limit: 10,
        kategori: state.selectedCategory != 'semua' ? state.selectedCategory : null,
        filter: state.activeTab != 'all' ? state.activeTab : null,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
      );

      final newPosts = result['posts'] as List<Post>;

      state = CommunityState(
        isLoading: false,
        isLoadingMore: false,
        posts: loadMore ? [...state.posts, ...newPosts] : newPosts,
        searchQuery: state.searchQuery,
        activeTab: state.activeTab,
        selectedCategory: state.selectedCategory,
        currentPage: result['current_page'] as int,
        lastPage: result['last_page'] as int,
        total: result['total'] as int,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts(loadMore: false);
  }

  void setActiveTab(String tab) {
    if (state.activeTab == tab) return;
    state = state.copyWith(activeTab: tab);
    refreshPosts();
  }

  void setCategory(String category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    refreshPosts();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    // Trigger debounce or reload
    refreshPosts();
  }

  Future<bool> createPost({
    required String judul,
    required String deskripsi,
    String? kategori,
    bool isAnonymous = false,
    String? gambar,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.createPost(
        judul: judul,
        deskripsi: deskripsi,
        kategori: kategori,
        isAnonymous: isAnonymous,
        gambar: gambar,
      );

      // Reload posts after creating
      await loadPosts();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> toggleLike(int postId) async {
    try {
      final repository = ref.read(communityRepositoryProvider);
      final result = await repository.toggleLike(postId);

      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            isLiked: result['is_liked'] as bool,
            apresiasi: result['apresiasi'] as int,
          );
        }
        return post;
      }).toList();

      state = state.copyWith(posts: updatedPosts);
    } catch (_) {}
  }

  Future<bool> deletePost(int postId) async {
    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.deletePost(postId);
      
      final updatedPosts = state.posts.where((p) => p.id != postId).toList();
      state = state.copyWith(posts: updatedPosts);
      return true;
    } catch (_) {
      return false;
    }
  }

  void updatePost(Post updatedPost) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == updatedPost.id) {
        return updatedPost;
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  Future<Map<String, dynamic>> optimisticToggleLike(int postId) async {
    final currentPost = state.posts.firstWhere((p) => p.id == postId);
    final wasLiked = currentPost.isLiked;
    final oldCount = currentPost.apresiasi;
    
    final newLiked = !wasLiked;
    final newCount = newLiked ? oldCount + 1 : oldCount - 1;
    
    final optimisticPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(isLiked: newLiked, apresiasi: newCount);
      }
      return post;
    }).toList();
    state = state.copyWith(posts: optimisticPosts);
    
    try {
      final repository = ref.read(communityRepositoryProvider);
      final result = await repository.toggleLike(postId);
      
      final syncedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(
            isLiked: result['is_liked'] as bool,
            apresiasi: result['apresiasi'] as int,
          );
        }
        return post;
      }).toList();
      state = state.copyWith(posts: syncedPosts);
      
      return result;
    } catch (e) {
      final revertedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(isLiked: wasLiked, apresiasi: oldCount);
        }
        return post;
      }).toList();
      state = state.copyWith(posts: revertedPosts);
      rethrow;
    }
  }

  void incrementCommentCount(int postId) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(komentar: post.komentar + 1);
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  void decrementCommentCount(int postId) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId && post.komentar > 0) {
        return post.copyWith(komentar: post.komentar - 1);
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  void setCommentCount(int postId, int count) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(komentar: count);
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }
}

final communityNotifierProvider =
    NotifierProvider<CommunityNotifier, CommunityState>(CommunityNotifier.new);

// ==================== Post Detail Service & Providers ====================

class PostDetailService {
  final Ref _ref;
  final int postId;
  
  PostDetailService(this._ref, this.postId);

  CommunityRepository get _repository => _ref.read(communityRepositoryProvider);

  Future<Post> getPost() async {
    return await _repository.getPostById(postId);
  }

  Future<List<Comment>> getComments() async {
    return await _repository.getComments(postId);
  }

  Future<Comment> addComment(String komentar) async {
    return await _repository.addComment(postId: postId, komentar: komentar);
  }

  Future<Map<String, dynamic>> toggleLike() async {
    return await _repository.toggleLike(postId);
  }

  Future<void> deleteComment(int commentId) async {
    await _repository.deleteComment(commentId);
  }
}

final postDetailServiceProvider = Provider.family<PostDetailService, int>(
  (ref, postId) => PostDetailService(ref, postId),
);

final postDetailProvider = FutureProvider.autoDispose.family<Post, int>(
  (ref, postId) async {
    final communityState = ref.read(communityNotifierProvider);
    final cachedPost = communityState.posts.where((p) => p.id == postId).firstOrNull;
    
    if (cachedPost != null) {
      return cachedPost;
    }
    
    final service = ref.read(postDetailServiceProvider(postId));
    return await service.getPost();
  },
);

final postCommentsProvider = FutureProvider.autoDispose.family<List<Comment>, int>(
  (ref, postId) async {
    try {
      final service = ref.read(postDetailServiceProvider(postId));
      final comments = await service.getComments();

      ref
          .read(communityNotifierProvider.notifier)
          .setCommentCount(postId, comments.length);

      return comments;
    } catch (e) {
      debugPrint('postCommentsProvider error: $e');
      rethrow;
    }
  },
);
