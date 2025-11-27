import 'package:flutter/foundation.dart';

@immutable
class PostUser {
  final int id;
  final String name;
  final String? profileImage;

  const PostUser({
    required this.id,
    required this.name,
    this.profileImage,
  });
}

@immutable
class Post {
  final int id;
  final String judul;
  final String deskripsi;
  final String? gambar;
  final int apresiasi;
  final int komentar;
  final PostUser user;
  final String? createdAt;
  final bool isLiked;

  const Post({
    required this.id,
    required this.judul,
    required this.deskripsi,
    this.gambar,
    required this.apresiasi,
    required this.komentar,
    required this.user,
    this.createdAt,
    this.isLiked = false,
  });

  Post copyWith({
    int? id,
    String? judul,
    String? deskripsi,
    String? gambar,
    int? apresiasi,
    int? komentar,
    PostUser? user,
    String? createdAt,
    bool? isLiked,
  }) {
    return Post(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      gambar: gambar ?? this.gambar,
      apresiasi: apresiasi ?? this.apresiasi,
      komentar: komentar ?? this.komentar,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

