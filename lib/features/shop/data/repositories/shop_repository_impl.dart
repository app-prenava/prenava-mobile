import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_remote_datasource.dart';
import '../models/product_model.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDatasource _remote;
  ShopRepositoryImpl(this._remote);

  @override
  Future<List<ProductModel>> fetchProducts() {
    return _remote.fetchProducts();
  }
}
