import 'package:flutter/foundation.dart';
import 'post.dart';

@immutable
class BidanProfileMeta {
  final int? bidanId;
  final String? name;
  final String? tempatPraktik;
  final String? alamatPraktik;
  final String? kota;
  final String? spesialisasi;
  final String? nomorSipb;

  const BidanProfileMeta({
    this.bidanId,
    this.name,
    this.tempatPraktik,
    this.alamatPraktik,
    this.kota,
    this.spesialisasi,
    this.nomorSipb,
  });
}

@immutable
class Comment {
  final int id;
  final int postId;
  final int userId;
  final String komentar;
  final String? createdAt;
  final PostUser? user;
  final bool isBidanReply;
  final bool isPinned;
  final bool suggestAppointment;
  final int? bidanUserId;
  final BidanProfileMeta? bidanProfile;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.komentar,
    this.createdAt,
    this.user,
    this.isBidanReply = false,
    this.isPinned = false,
    this.suggestAppointment = false,
    this.bidanUserId,
    this.bidanProfile,
  });
}
