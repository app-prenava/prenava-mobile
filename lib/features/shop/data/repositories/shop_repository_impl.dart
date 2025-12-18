import '../../domain/entities/product.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_datasource.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDatasource remoteDatasource;

  ShopRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Map<String, dynamic>> getAllProducts({int page = 1, int limit = 30, String? category}) {
    return remoteDatasource.getAllProducts(page: page, limit: limit, category: category);
  }

  @override
  Future<Map<String, dynamic>> getMyProducts({int page = 1, int limit = 30}) {
    return remoteDatasource.getMyProducts(page: page, limit: limit);
  }

  @override
  Future<Product> createProduct({
    required Map<String, dynamic> data,
    required String photoPath,
  }) {
    return remoteDatasource.createProduct(data: data, photoPath: photoPath);
  }

  @override
  Future<Product> updateProduct({
    required int productId,
    required Map<String, dynamic> data,
    String? photoPath,
  }) {
    return remoteDatasource.updateProduct(
      productId: productId,
      data: data,
      photoPath: photoPath,
    );
  }

  @override
  Future<void> deleteProduct(int productId) {
    return remoteDatasource.deleteProduct(productId);
  }

  @override
  Future<Map<String, dynamic>> getReviews({
    required int productId,
    int page = 1,
    int limit = 20,
  }) {
    return remoteDatasource.getReviews(
      productId: productId,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<ShopReview> upsertReview({
    required int productId,
    required int rating,
    String? comment,
  }) {
    return remoteDatasource.upsertReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<void> deleteReview({
    required int productId,
    required int reviewId,
  }) {
    return remoteDatasource.deleteReview(
      productId: productId,
      reviewId: reviewId,
    );
  }
}
