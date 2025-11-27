import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import 'post_model.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.komentar,
    super.createdAt,
    super.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Parse user data if present
    final userData = json['user'] as Map<String, dynamic>?;
    final PostUser? user = userData != null 
        ? PostUserModel.fromJson(userData)
        : null;

    return CommentModel(
      id: json['id'] as int? ?? json['comment_id'] as int? ?? 0,
      postId: json['post_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      komentar: json['komentar']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'komentar': komentar,
      'created_at': createdAt,
    };
  }
}

