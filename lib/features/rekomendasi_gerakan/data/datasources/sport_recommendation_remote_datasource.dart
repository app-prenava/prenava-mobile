import 'package:dio/dio.dart';
import '../models/sport_recommendation_model.dart';

class SportRecommendationRemoteDatasource {
  final Dio _dio;

  SportRecommendationRemoteDatasource(this._dio);

  /// GET /api/recomendation/sports/get
  /// Fetches existing sport recommendations based on user's stored assessment data.
  Future<SportRecommendationResponseModel> getRecommendations() async {
    try {
      final response = await _dio.get('/recomendation/sports/get');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return SportRecommendationResponseModel.fromJson(data);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to fetch sport recommendations');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data is Map
            ? e.response?.data['message']
            : null;
        throw Exception(msg ?? 'Failed to fetch sport recommendations');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  /// POST /api/recomendation/sports/create
  /// Submits assessment data and returns new sport recommendations.
  Future<SportRecommendationResponseModel> createRecommendation(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _dio.post(
        '/recomendation/sports/create',
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return SportRecommendationResponseModel.fromJson(data);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to create sport recommendation');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data is Map
            ? e.response?.data['message']
            : null;
        throw Exception(msg ?? 'Failed to create sport recommendation');
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
