class Product {
  final int? productId;
  final int? userId;
  final String productName;
  final String price;
  final String url;
  final String? photo;
  final String? createdAt;
  final String? updatedAt;
  final String? sellerName;

  const Product({
    this.productId,
    this.userId,
    required this.productName,
    required this.price,
    required this.url,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.sellerName,
  });
}

