import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.productId,
    super.userId,
    required super.productName,
    required super.price,
    required super.url,
    super.photo,
    super.createdAt,
    super.updatedAt,
    super.sellerName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Fix localhost URL to use server IP
    String? photoUrl = json['photo']?.toString();
    if (photoUrl != null && photoUrl.contains('localhost')) {
      photoUrl = photoUrl.replaceAll('http://localhost:8000', 'http://192.168.1.16:8000');
    }

    return ProductModel(
      productId: json['product_id'] as int?,
      userId: json['user_id'] as int?,
      productName: json['product_name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      url: json['url']?.toString() ?? '',
      photo: photoUrl,
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
    if (createdAt != null) map['created_at'] = createdAt;
    if (updatedAt != null) map['updated_at'] = updatedAt;
    if (sellerName != null) map['seller_name'] = sellerName;
    
    return map;
  }
}
