import '../../domain/entities/product.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_datasource.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDatasource remoteDatasource;

  ShopRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Map<String, dynamic>> getAllProducts({int page = 1, int limit = 30}) {
    return remoteDatasource.getAllProducts(page: page, limit: limit);
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
}
