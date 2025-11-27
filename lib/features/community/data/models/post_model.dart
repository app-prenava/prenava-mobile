import '../../../../core/utils/image_url_helper.dart';
import '../../domain/entities/post.dart';

class PostUserModel extends PostUser {
  const PostUserModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    // Normalize profile image URL
    final profileImage = ImageUrlHelper.normalizeImageUrl(json['profile_image']?.toString());
    
    return PostUserModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      profileImage: profileImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
    };
  }
}

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.judul,
    required super.deskripsi,
    super.gambar,
    required super.apresiasi,
    required super.komentar,
    required super.user,
    super.createdAt,
    super.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Parse user data
    final userData = json['user'] as Map<String, dynamic>?;
    final user = userData != null 
        ? PostUserModel.fromJson(userData)
        : const PostUserModel(id: 0, name: 'Unknown');
    
    // Normalize gambar URL if present
    final gambar = ImageUrlHelper.normalizeImageUrl(json['gambar']?.toString());

    // Handle komentar: could be int (count) or List (array of comments)
    int komentarCount = 0;
    final komentarValue = json['komentar'];
    if (komentarValue is int) {
      komentarCount = komentarValue;
    } else if (komentarValue is List) {
      komentarCount = komentarValue.length;
    } else if (json['komen'] is int) {
      komentarCount = json['komen'] as int;
    }

    return PostModel(
      id: json['id'] as int? ?? json['post_id'] as int? ?? 0,
      judul: json['judul']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
      gambar: gambar,
      apresiasi: json['apresiasi'] as int? ?? 0,
      komentar: komentarCount,
      user: user,
      createdAt: json['created_at']?.toString(),
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'apresiasi': apresiasi,
      'komentar': komentar,
      'user': (user as PostUserModel).toJson(),
      'created_at': createdAt,
      'is_liked': isLiked,
    };
  }
}

