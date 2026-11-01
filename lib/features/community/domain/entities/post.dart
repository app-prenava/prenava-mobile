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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          profileImage == other.profileImage;

  @override
  int get hashCode => Object.hash(id, name, profileImage);
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
  final String kategori;
  final String kategoriLabel;
  final bool isAnonymous;
  final String? gestationalContextLabel;
  final bool hasBidanReply;

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
    this.kategori = 'umum',
    this.kategoriLabel = 'Diskusi Umum',
    this.isAnonymous = false,
    this.gestationalContextLabel,
    this.hasBidanReply = false,
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
    String? kategori,
    String? kategoriLabel,
    bool? isAnonymous,
    String? gestationalContextLabel,
    bool? hasBidanReply,
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
      kategori: kategori ?? this.kategori,
      kategoriLabel: kategoriLabel ?? this.kategoriLabel,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      gestationalContextLabel: gestationalContextLabel ?? this.gestationalContextLabel,
      hasBidanReply: hasBidanReply ?? this.hasBidanReply,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          judul == other.judul &&
          deskripsi == other.deskripsi &&
          gambar == other.gambar &&
          apresiasi == other.apresiasi &&
          komentar == other.komentar &&
          user == other.user &&
          createdAt == other.createdAt &&
          isLiked == other.isLiked &&
          kategori == other.kategori &&
          kategoriLabel == other.kategoriLabel &&
          isAnonymous == other.isAnonymous &&
          gestationalContextLabel == other.gestationalContextLabel &&
          hasBidanReply == other.hasBidanReply;

  @override
  int get hashCode => Object.hash(
        id,
        judul,
        deskripsi,
        gambar,
        apresiasi,
        komentar,
        user,
        createdAt,
        isLiked,
        kategori,
        kategoriLabel,
        isAnonymous,
        gestationalContextLabel,
        hasBidanReply,
      );
}
