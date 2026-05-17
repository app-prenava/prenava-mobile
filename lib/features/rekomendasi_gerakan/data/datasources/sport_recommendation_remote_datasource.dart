import 'package:dio/dio.dart';
import '../../domain/entities/sport_recommendation.dart';
import '../models/sport_recommendation_model.dart';

class SportRecommendationRemoteDatasource {
  final Dio _dio;

  SportRecommendationRemoteDatasource(this._dio);

  static const String serviceUnavailableMessage =
      'Layanan sedang tidak tersedia. Silakan coba beberapa saat lagi.';

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
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        throw Exception(serviceUnavailableMessage);
      }

      if (e.response != null) {
        final msg = e.response?.data is Map
            ? e.response?.data['message']
            : null;
        throw Exception(msg ?? 'Failed to fetch sport recommendations');
      }

      throw Exception(serviceUnavailableMessage);
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
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        throw Exception(serviceUnavailableMessage);
      }

      if (e.response != null) {
        final msg = e.response?.data is Map
            ? e.response?.data['message'] ?? e.response?.data.toString()
            : null;
        throw Exception(msg ?? 'Failed to create sport recommendation');
      }

      throw Exception(serviceUnavailableMessage);
    }
  }

  /// GET /api/recomendation/sports/assessment
  /// Fetches existing assessment data for auto-filling the form.
  Future<Map<String, dynamic>?> getExistingAssessment() async {
    try {
      final response = await _dio.get('/recomendation/sports/assessment');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['has_assessment'] == true) {
          return data['assessment'] as Map<String, dynamic>;
        }
        return null;
      }
      return null;
    } on DioException {
      return null;
    }
  }

  /// GET /api/recomendation/sports/all
  /// Fetches all sports from admin data (fallback when ML is unavailable)
  Future<List<SportRecommendation>> getAllSports() async {
    try {
      final response = await _dio.get('/recomendation/sports/all');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          return (data['data'] as List)
              .map(
                (e) => SportRecommendationModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to fetch all sports');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        throw Exception(serviceUnavailableMessage);
      }

      if (e.response != null) {
        final msg = e.response?.data is Map
            ? e.response?.data['message']
            : null;
        throw Exception(msg ?? 'Failed to fetch all sports');
      }

      throw Exception(serviceUnavailableMessage);
    }
  }
}