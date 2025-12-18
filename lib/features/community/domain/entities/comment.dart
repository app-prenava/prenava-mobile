import 'package:flutter/foundation.dart';
import 'post.dart';

@immutable
class Comment {
  final int id;
  final int postId;
  final int userId;
  final String komentar;
  final String? createdAt;
  final PostUser? user;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.komentar,
    this.createdAt,
    this.user,
  });
}











