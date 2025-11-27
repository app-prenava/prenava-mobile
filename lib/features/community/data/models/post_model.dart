import '../../../../core/utils/image_url_helper.dart';
import '../../domain/entities/post.dart';

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

class PostUserModel extends PostUser {
  const PostUserModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    final profileImageUrl = json['photo']?.toString() ?? 
                            json['profile_image']?.toString() ?? 
                            json['avatar']?.toString();
    
    return PostUserModel(
      id: _parseInt(json['id'] ?? json['user_id']),
      name: json['name']?.toString() ?? json['username']?.toString() ?? 'Unknown',
      profileImage: ImageUrlHelper.normalizeImageUrl(profileImageUrl),
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
    final userData = json['user'] as Map<String, dynamic>?;
    final user = userData != null 
        ? PostUserModel.fromJson(userData)
        : const PostUserModel(id: 0, name: 'Unknown');
    
    final gambar = ImageUrlHelper.normalizeImageUrl(json['gambar']?.toString());

    int komentarCount = 0;
    final komentarValue = json['komentar'] ?? json['komen'];
    if (komentarValue is int) {
      komentarCount = komentarValue;
    } else if (komentarValue is String) {
      komentarCount = int.tryParse(komentarValue) ?? 0;
    } else if (komentarValue is List) {
      komentarCount = komentarValue.length;
    }

    return PostModel(
      id: _parseInt(json['id'] ?? json['post_id']),
      judul: json['judul']?.toString() ?? '',
      deskripsi: json['deskripsi']?.toString() ?? '',
      gambar: gambar,
      apresiasi: _parseInt(json['apresiasi']),
      komentar: komentarCount,
      user: user,
      createdAt: json['created_at']?.toString(),
      isLiked: json['is_liked'] as bool? ?? false,
    );
  }

  factory PostModel.fromThreadsJson(Map<String, dynamic> json) {
    PostUserModel user;
    final authorData = json['author'] as Map<String, dynamic>?;
    if (authorData != null) {
      final profileImageUrl = authorData['photo']?.toString() ?? 
                              authorData['profile_image']?.toString() ?? 
                              authorData['avatar']?.toString();
      
      user = PostUserModel(
        id: _parseInt(authorData['id'] ?? authorData['user_id']),
        name: authorData['name']?.toString() ?? authorData['username']?.toString() ?? 'Unknown',
        profileImage: ImageUrlHelper.normalizeImageUrl(profileImageUrl),
      );
    } else {
      final userData = json['user'] as Map<String, dynamic>?;
      user = userData != null 
          ? PostUserModel.fromJson(userData)
          : const PostUserModel(id: 0, name: 'Unknown');
    }
    
    final gambar = ImageUrlHelper.normalizeImageUrl(
      json['image']?.toString() ?? json['gambar']?.toString()
    );

    int komentarCount = 0;
    final commentsValue = json['comments'] ?? json['comments_count'];
    if (commentsValue is int) {
      komentarCount = commentsValue;
    } else if (commentsValue is String) {
      komentarCount = int.tryParse(commentsValue) ?? 0;
    } else if (commentsValue is List) {
      komentarCount = commentsValue.length;
    }

    int likesCount = 0;
    final likesValue = json['likes'] ?? json['likes_count'] ?? json['apresiasi'];
    if (likesValue is int) {
      likesCount = likesValue;
    } else if (likesValue is String) {
      likesCount = int.tryParse(likesValue) ?? 0;
    } else if (likesValue is List) {
      likesCount = likesValue.length;
    }

    return PostModel(
      id: _parseInt(json['id'] ?? json['thread_id'] ?? json['post_id']),
      judul: json['title']?.toString() ?? json['judul']?.toString() ?? '',
      deskripsi: json['content']?.toString() ?? json['deskripsi']?.toString() ?? '',
      gambar: gambar,
      apresiasi: likesCount,
      komentar: komentarCount,
      user: user,
      createdAt: json['created_at']?.toString(),
      isLiked: json['is_liked'] as bool? ?? json['liked'] as bool? ?? false,
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
