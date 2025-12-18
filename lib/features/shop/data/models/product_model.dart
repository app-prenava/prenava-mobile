import '../../../../core/utils/image_url_helper.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.productId,
    super.userId,
    required super.productName,
    required super.price,
    required super.url,
    super.photo,
    super.description,
    super.category,
    super.averageRating,
    super.ratingCount,
    super.createdAt,
    super.updatedAt,
    super.sellerName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Log raw photo data from backend
    final rawPhoto = json['photo']?.toString();
    if (rawPhoto != null) {
      print('ProductModel: Raw photo from backend: $rawPhoto');
    } else {
      print('ProductModel: No photo field in response');
    }
    
    // Normalize image URL using helper
    final photoUrl = ImageUrlHelper.normalizeImageUrl(rawPhoto);
    
    if (photoUrl != null) {
      print('ProductModel: Normalized photo URL: $photoUrl');
    }

    return ProductModel(
      productId: json['product_id'] as int?,
      userId: json['user_id'] as int?,
      productName: json['product_name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      url: json['url']?.toString() ?? '',
      photo: photoUrl,
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      averageRating: (json['average_rating'] is num)
          ? (json['average_rating'] as num).toDouble()
          : 0,
      ratingCount: (json['rating_count'] as int?) ?? 0,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      sellerName: json['seller_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'product_name': productName,
      'price': price,
      'url': url,
    };
    
    if (productId != null) map['product_id'] = productId;
    if (userId != null) map['user_id'] = userId;
    if (photo != null) map['photo'] = photo;
    if (description != null) map['description'] = description;
    if (category != null) map['category'] = category;
    if (averageRating != 0) map['average_rating'] = averageRating;
    if (ratingCount != 0) map['rating_count'] = ratingCount;
    if (createdAt != null) map['created_at'] = createdAt;
    if (updatedAt != null) map['updated_at'] = updatedAt;
    if (sellerName != null) map['seller_name'] = sellerName;
    
    return map;
  }
}
