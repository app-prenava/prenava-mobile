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

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    PostUser? user;
    
    final authorData = json['author'] as Map<String, dynamic>?;
    final userData = json['user'] as Map<String, dynamic>?;
    
    if (authorData != null) {
      final profileImageUrl = authorData['photo']?.toString() ?? 
                              authorData['profile_image']?.toString() ?? 
                              authorData['avatar']?.toString();
      
      user = PostUserModel(
        id: _parseInt(authorData['id'] ?? authorData['user_id']),
        name: authorData['name']?.toString() ?? authorData['username']?.toString() ?? 'Unknown',
        profileImage: profileImageUrl,
      );
    } else if (userData != null) {
      user = PostUserModel.fromJson(userData);
    } else {
      // Some APIs might return user info flattened on the comment object
      final flattenedName = json['name']?.toString() ??
          json['nama']?.toString() ??
          json['username']?.toString();

      if (flattenedName != null && flattenedName.isNotEmpty) {
        final profileImageUrl = json['photo']?.toString() ??
            json['profile_image']?.toString() ??
            json['avatar']?.toString();

        user = PostUserModel(
          id: _parseInt(json['user_id']),
          name: flattenedName,
          profileImage: profileImageUrl,
        );
      }
    }

    return CommentModel(
      id: _parseInt(json['id'] ?? json['comment_id']),
      postId: _parseInt(json['post_id'] ?? json['thread_id']),
      userId: _parseInt(json['user_id'] ?? json['author_id']),
      komentar: json['content']?.toString() ?? json['komentar']?.toString() ?? json['body']?.toString() ?? '',
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
