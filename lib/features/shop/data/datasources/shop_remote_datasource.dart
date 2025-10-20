import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ShopRemoteDatasource {
  final Dio _dio;
  ShopRemoteDatasource(this._dio);

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get('/products');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          final List<dynamic> list = data['data'] as List<dynamic>;
          return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
        } else if (data is List) {
          return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        throw Exception('Format JSON tidak dikenali dari API produk');
      }

      throw Exception('Gagal memuat produk: Status ${response.statusCode}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message'] as String?)
          : e.message;
      throw Exception('Gagal memuat produk: ${message ?? code?.toString() ?? 'unknown'}');
    }
  }
}
