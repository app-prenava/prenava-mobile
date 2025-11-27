import '../../../../core/utils/image_url_helper.dart';
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
    // Normalize image URL using helper
    final photoUrl = ImageUrlHelper.normalizeImageUrl(json['photo']?.toString());

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

