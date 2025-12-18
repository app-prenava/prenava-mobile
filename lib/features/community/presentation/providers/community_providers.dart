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
  final List<Post> posts;
  final String? error;
  final String searchQuery;
  final String selectedCategory;

  const CommunityState({
    this.isLoading = false,
    this.posts = const [],
    this.error,
    this.searchQuery = '',
    this.selectedCategory = 'Terbaru',
  });

  const CommunityState.initial()
      : isLoading = false,
        posts = const [],
        error = null,
        searchQuery = '',
        selectedCategory = 'Terbaru';

  CommunityState copyWith({
    bool? isLoading,
    List<Post>? posts,
    String? error,
    bool clearError = false,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return CommunityState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  /// Get filtered posts based on search query and category
  List<Post> get displayPosts {
    var filtered = posts;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((post) {
        return post.judul.toLowerCase().contains(searchQuery.toLowerCase()) ||
            post.deskripsi.toLowerCase().contains(searchQuery.toLowerCase()) ||
            post.user.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Filter by selected category (except 'Terbaru')
    if (selectedCategory != 'Terbaru') {
      filtered = filtered
          .where(
            (post) =>
                post.judul.toLowerCase() ==
                selectedCategory.toLowerCase(),
          )
          .toList();
    }

    // Always sort by newest first
    filtered = List.from(filtered)
      ..sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));

    return filtered;
  }
}

// ==================== Community Notifier ====================

class CommunityNotifier extends Notifier<CommunityState> {
  @override
  CommunityState build() {
    // Load posts when initialized
    Future.microtask(() => loadPosts());
    return const CommunityState.initial();
  }

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(communityRepositoryProvider);
      final posts = await repository.getAllPosts();

      state = state.copyWith(
        isLoading: false,
        posts: posts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  Future<bool> createPost({
    required String judul,
    required String deskripsi,
    String? gambar,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.createPost(
        judul: judul,
        deskripsi: deskripsi,
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

      // Update local state
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
    } catch (e) {
      // Silently fail or show error
    }
  }

  Future<bool> deletePost(int postId) async {
    try {
      final repository = ref.read(communityRepositoryProvider);
      await repository.deletePost(postId);
      
      // Remove from local state
      final updatedPosts = state.posts.where((p) => p.id != postId).toList();
      state = state.copyWith(posts: updatedPosts);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update a single post in the list (used for syncing detail with list)
  void updatePost(Post updatedPost) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == updatedPost.id) {
        return updatedPost;
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  /// Optimistic like update - immediately update UI, then sync with server
  Future<Map<String, dynamic>> optimisticToggleLike(int postId) async {
    // Get current state
    final currentPost = state.posts.firstWhere((p) => p.id == postId);
    final wasLiked = currentPost.isLiked;
    final oldCount = currentPost.apresiasi;
    
    // Optimistic update
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
      // Call API
      final repository = ref.read(communityRepositoryProvider);
      final result = await repository.toggleLike(postId);
      
      // Sync with actual server response
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
      // Revert on error
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

  /// Increment comment count for a post
  void incrementCommentCount(int postId) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(komentar: post.komentar + 1);
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  /// Decrement comment count for a post (used when deleting a comment)
  void decrementCommentCount(int postId) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId && post.komentar > 0) {
        return post.copyWith(komentar: post.komentar - 1);
      }
      return post;
    }).toList();
    state = state.copyWith(posts: updatedPosts);
  }

  /// Set exact comment count for a post (sync with backend)
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

// ==================== Post Detail State ====================

class PostDetailState {
  final bool isLoading;
  final Post? post;
  final List<Comment> comments;
  final bool isLoadingComments;
  final String? error;

  const PostDetailState({
    this.isLoading = false,
    this.post,
    this.comments = const [],
    this.isLoadingComments = false,
    this.error,
  });

  const PostDetailState.initial()
      : isLoading = false,
        post = null,
        comments = const [],
        isLoadingComments = false,
        error = null;

  PostDetailState copyWith({
    bool? isLoading,
    Post? post,
    List<Comment>? comments,
    bool? isLoadingComments,
    String? error,
    bool clearError = false,
  }) {
    return PostDetailState(
      isLoading: isLoading ?? this.isLoading,
      post: post ?? this.post,
      comments: comments ?? this.comments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ==================== Post Detail Service ====================

/// Service class for post detail operations
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

/// Provider for post detail service
final postDetailServiceProvider = Provider.family<PostDetailService, int>(
  (ref, postId) => PostDetailService(ref, postId),
);

/// Provider for loading post detail
/// First checks local cache (from list), then fetches from API if needed
final postDetailProvider = FutureProvider.autoDispose.family<Post, int>(
  (ref, postId) async {
    // First try to get from local cache (community list)
    final communityState = ref.read(communityNotifierProvider);
    final cachedPost = communityState.posts.where((p) => p.id == postId).firstOrNull;
    
    if (cachedPost != null) {
      return cachedPost;
    }
    
    // No cache, fetch from API
    final service = ref.read(postDetailServiceProvider(postId));
    return await service.getPost();
  },
);

/// Provider for loading comments
final postCommentsProvider = FutureProvider.autoDispose.family<List<Comment>, int>(
  (ref, postId) async {
    try {
      final service = ref.read(postDetailServiceProvider(postId));
      final comments = await service.getComments();

      // Sync comment count with actual comments length
      ref
          .read(communityNotifierProvider.notifier)
          .setCommentCount(postId, comments.length);

      return comments;
    } catch (e) {
      print('postCommentsProvider error: $e');
      rethrow;
    }
  },
);

