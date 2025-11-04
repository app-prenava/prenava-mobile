import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    super.id,
    super.name,
    super.photo,
    super.url,
    super.isActive,
    super.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['photo']?.toString();
    // Fix localhost URL to use server IP
    if (photoUrl != null && photoUrl.contains('localhost')) {
      photoUrl = photoUrl.replaceAll('http://localhost:8000', 'http://192.168.1.16:8000');
    }

    return BannerModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      photo: photoUrl,
      url: json['url'] as String?,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'url': url,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}

