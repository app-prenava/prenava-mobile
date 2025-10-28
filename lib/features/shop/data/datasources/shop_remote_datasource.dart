import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ShopRemoteDatasource {
  final Dio _dio;

  ShopRemoteDatasource(this._dio);

  // GET /api/shop/all - Get all products with pagination
  Future<Map<String, dynamic>> getAllProducts({int page = 1, int limit = 30}) async {
    try {
      final response = await _dio.get(
        '/shop/all',
        queryParameters: {'page': page, 'data': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final products = (data['data'] as List?)
                ?.map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];

        return {
          'products': products,
          'current_page': data['current_page'] ?? 1,
          'last_page': data['last_page'] ?? 1,
          'total': data['total'] ?? 0,
          'per_page': data['per_page'] ?? limit,
        };
      }

      return {
        'products': <ProductModel>[],
        'current_page': 1,
        'last_page': 1,
        'total': 0,
        'per_page': limit,
      };
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil produk');
    }
  }

  // GET /api/shop - Get my products
  Future<Map<String, dynamic>> getMyProducts({int page = 1, int limit = 30}) async {
    try {
      final response = await _dio.get(
        '/shop',
        queryParameters: {'page': page, 'data': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final products = (data['data'] as List?)
                ?.map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];

        return {
          'products': products,
          'current_page': data['current_page'] ?? 1,
          'last_page': data['last_page'] ?? 1,
          'total': data['total'] ?? 0,
          'per_page': data['per_page'] ?? limit,
        };
      }

      return {
        'products': <ProductModel>[],
        'current_page': 1,
        'last_page': 1,
        'total': 0,
        'per_page': limit,
      };
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil produk');
    }
  }

  // POST /api/shop/create - Create new product
  Future<ProductModel> createProduct({
    required Map<String, dynamic> data,
    required String photoPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'product_name': data['product_name'],
        'price': data['price'],
        'url': data['url'],
        'photo': await MultipartFile.fromFile(
          photoPath,
          filename: photoPath.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/shop/create',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('product')) {
          return ProductModel.fromJson(responseData['product'] as Map<String, dynamic>);
        }
        return ProductModel.fromJson(responseData);
      }

      throw Exception('Gagal membuat produk');
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal membuat produk');
    }
  }

  // POST /api/shop/update/{id} - Update product
  Future<ProductModel> updateProduct({
    required int productId,
    required Map<String, dynamic> data,
    String? photoPath,
  }) async {
    try {
      dynamic requestData;

      if (photoPath != null) {
        // With photo - use multipart
        final formFields = <String, dynamic>{};
        data.forEach((key, value) {
          formFields[key] = value.toString();
        });

        requestData = FormData.fromMap({
          ...formFields,
          'photo': await MultipartFile.fromFile(
            photoPath,
            filename: photoPath.split('/').last,
          ),
        });
      } else {
        // Without photo - use JSON
        requestData = data;
      }

      final response = await _dio.post(
        '/shop/update/$productId',
        data: requestData,
        options: Options(
          contentType: photoPath != null ? 'multipart/form-data' : 'application/json',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('product')) {
          return ProductModel.fromJson(responseData['product'] as Map<String, dynamic>);
        }
        return ProductModel.fromJson(responseData);
      }

      throw Exception('Gagal mengupdate produk');
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal mengupdate produk');
    }
  }

  // POST /api/shop/delete/{id} - Delete product
  Future<void> deleteProduct(int productId) async {
    try {
      final response = await _dio.post('/shop/delete/$productId');

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus produk');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Produk tidak ditemukan');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Anda tidak punya izin untuk menghapus produk ini');
      }
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal menghapus produk');
    }
  }
}
