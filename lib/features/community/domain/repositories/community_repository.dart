import '../entities/post.dart';
import '../entities/comment.dart';

abstract class CommunityRepository {
  /// Get all posts
  Future<List<Post>> getAllPosts();

  /// Get post by id
  Future<Post> getPostById(int id);

  /// Create new post
  Future<Post> createPost({
    required String judul,
    required String deskripsi,
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

  /// Delete post by id
  Future<void> deletePost(int postId);

  /// Delete all posts (admin)
  Future<void> deleteAllPosts();
}

