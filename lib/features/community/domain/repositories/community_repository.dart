import '../entities/post.dart';
import '../entities/comment.dart';

abstract class CommunityRepository {
  /// Get all posts with pagination, category, filter, and search
  Future<Map<String, dynamic>> getAllPosts({
    int page = 1,
    int limit = 10,
    String? kategori,
    String? filter,
    String? search,
  });

  /// Get post by id
  Future<Post> getPostById(int id);

  /// Create new post with category and anonymity options
  Future<Post> createPost({
    required String judul,
    required String deskripsi,
    String? kategori,
    bool isAnonymous = false,
    String? gambar,
  });

  /// Toggle like on a post
  Future<Map<String, dynamic>> toggleLike(int postId);

  /// Get comments for a post
  Future<List<Comment>> getComments(int postId);

  /// Add comment to a post
  Future<Comment> addComment({
    required int postId,
    required String komentar,
  });

  /// Delete a single comment (reply) by id
  Future<void> deleteComment(int commentId);

  /// Delete post by id
  Future<void> deletePost(int postId);

  /// Delete all posts (admin)
  Future<void> deleteAllPosts();
}
