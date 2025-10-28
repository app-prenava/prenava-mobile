import '../entities/product.dart';

abstract class ShopRepository {
  Future<Map<String, dynamic>> getAllProducts({int page = 1, int limit = 30});
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
}
