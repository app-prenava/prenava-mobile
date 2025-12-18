import '../../domain/entities/post.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDatasource remoteDatasource;

  CommunityRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Post>> getAllPosts() {
    return remoteDatasource.getAllPosts();
  }

  @override
  Future<Post> getPostById(int id) {
    return remoteDatasource.getPostById(id);
  }

  @override
  Future<Post> createPost({
    required String judul,
    required String deskripsi,
    String? gambar,
  }) {
    return remoteDatasource.createPost(
      judul: judul,
      deskripsi: deskripsi,
      gambar: gambar,
    );
  }

  @override
  Future<Map<String, dynamic>> toggleLike(int postId) {
    return remoteDatasource.toggleLike(postId);
  }

  @override
  Future<List<Comment>> getComments(int postId) {
    return remoteDatasource.getComments(postId);
  }

  @override
  Future<Comment> addComment({
    required int postId,
    required String komentar,
  }) {
    return remoteDatasource.addComment(postId: postId, komentar: komentar);
  }

  @override
  Future<void> deleteComment(int commentId) {
    return remoteDatasource.deleteComment(commentId);
  }

  @override
  Future<void> deletePost(int postId) {
    return remoteDatasource.deletePost(postId);
  }

  @override
  Future<void> deleteAllPosts() {
    return remoteDatasource.deleteAllPosts();
  }
}

