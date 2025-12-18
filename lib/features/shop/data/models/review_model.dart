import '../../domain/entities/review.dart';

class ShopReviewModel extends ShopReview {
  const ShopReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.rating,
    super.comment,
    super.createdAt,
    super.userName,
    super.userProfileImage,
  });

  factory ShopReviewModel.fromJson(Map<String, dynamic> json) {
    return ShopReviewModel(
      id: json['id'] as int? ?? json['review_id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      rating: json['rating'] as int? ?? (json['stars'] as int? ?? 0),
      comment: json['comment']?.toString() ?? json['review']?.toString(),
      createdAt: json['created_at']?.toString(),
      userName: json['user_name']?.toString() ??
          json['user']?['name']?.toString() ??
          'Unknown',
      userProfileImage: json['user_profile_image']?.toString() ??
          (json['user']?['profile_image']?.toString()),
    );
  }
}

