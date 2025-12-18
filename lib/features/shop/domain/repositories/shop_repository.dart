import '../entities/product.dart';
import '../entities/review.dart';

abstract class ShopRepository {
  Future<Map<String, dynamic>> getAllProducts({int page = 1, int limit = 30, String? category});
  Future<Map<String, dynamic>> getMyProducts({int page = 1, int limit = 30});
  Future<Product> createProduct({
    required Map<String, dynamic> data,
    required String photoPath,
  });
  Future<Product> updateProduct({
    required int productId,
    required Map<String, dynamic> data,
    String? photoPath,
  });
  Future<void> deleteProduct(int productId);

  Future<Map<String, dynamic>> getReviews({
    required int productId,
    int page,
    int limit,
  });

  Future<ShopReview> upsertReview({
    required int productId,
    required int rating,
    String? comment,
  });

  Future<void> deleteReview({
    required int productId,
    required int reviewId,
  });
}
