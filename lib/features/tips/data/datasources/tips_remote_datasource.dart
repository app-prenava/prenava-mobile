import 'package:dio/dio.dart';
import '../models/tip_category_model.dart';
import '../models/pregnancy_tip_model.dart';

class TipsRemoteDatasource {
  final Dio _dio;

  TipsRemoteDatasource(this._dio);

  // GET /api/tips/categories - Ambil semua kategori
  Future<List<TipCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get('/tips/categories');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'berhasil') {
          return (data['data'] as List)
              .map((json) => TipCategoryModel.fromJson(
                    json as Map<String, dynamic>,
                  ))
              .toList();
        }
      }
      throw Exception('Failed to load categories');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load categories',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // GET /api/tips - Ambil semua tips dengan filter
  Future<List<PregnancyTipModel>> getTips({
    int? categoryId,
    String? categorySlug,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }
      if (categorySlug != null) {
        queryParams['category_slug'] = categorySlug;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        '/tips',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'berhasil') {
          return (data['data'] as List)
              .map((json) => PregnancyTipModel.fromJson(
                    json as Map<String, dynamic>,
                  ))
              .toList();
        }
      }
      throw Exception('Failed to load tips');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load tips',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // GET /api/tips/:id - Ambil detail tip
  Future<PregnancyTipModel> getTipById(int id) async {
    try {
      final response = await _dio.get('/tips/$id');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'berhasil') {
          return PregnancyTipModel.fromJson(
            data['data'] as Map<String, dynamic>,
          );
        }
      }
      throw Exception('Failed to load tip');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load tip',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}

