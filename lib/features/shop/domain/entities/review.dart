class ShopReview {
  final int id;
  final int productId;
  final int userId;
  final int rating;
  final String? comment;
  final String? createdAt;
  final String userName;
  final String? userProfileImage;

  const ShopReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.userName = 'Unknown',
    this.userProfileImage,
  });
}

