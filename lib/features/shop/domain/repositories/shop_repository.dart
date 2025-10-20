import '../../data/models/product_model.dart';

abstract class ShopRepository {
  Future<List<ProductModel>> fetchProducts();
}
