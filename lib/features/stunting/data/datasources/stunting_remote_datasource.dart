import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/core/network/dio_client.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

final stuntingRemoteDataSourceProvider = Provider<StuntingRemoteDataSource>((ref) {
  final dio = ref.watch(appDioProvider);
  return StuntingRemoteDataSource(dio);
});

class StuntingRemoteDataSource {
  final Dio _dio;

  StuntingRemoteDataSource(this._dio);

  Future<List<StuntingQuestion>> getQuestions() async {
    try {
      final response = await _dio.get('/stunting/questions');
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((q) => StuntingQuestion.fromJson(q)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load questions');
    } catch (e) {
      rethrow;
    }
  }

  Future<PredictionResult> predict(Map<String, dynamic> inputData) async {
    try {
      final response = await _dio.post('/stunting/predict', data: inputData);
      if (response.data['success'] == true) {
        return PredictionResult.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Prediction failed');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 401:
          throw Exception('Sesi login berakhir. Silakan login kembali.');
        case 403:
          throw Exception('Akses ditolak. Silakan hubungi administrator.');
        case 422:
          final msg = e.response?.data?['message'];
          throw Exception(msg ?? 'Data tidak valid. Periksa kembali isian form.');
        case 500:
          throw Exception('Terjadi kesalahan server. Silakan coba lagi.');
        case 504:
          throw Exception(
            'Server ML sedang tidak tersedia. Silakan coba lagi dalam beberapa saat.',
          );
        default:
          final msg = e.response?.data?['message'];
          throw Exception(msg ?? 'Terjadi kesalahan jaringan. Periksa koneksi internet.');
      }
    }
  }

  Future<RecommendationResponse> getRecommendations(int predictionId) async {
    try {
      final response = await _dio.get('/stunting/recommendations/$predictionId');
      return RecommendationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StuntingHistoryItem>> getHistory() async {
    try {
      final response = await _dio.get('/stunting/history');
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((h) => StuntingHistoryItem.fromJson(h)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load history');
    } catch (e) {
      rethrow;
    }
  }

  Future<PredictionResult> getHistoryDetail(int id) async {
    try {
      final response = await _dio.get('/stunting/history/$id');
      if (response.data['success'] == true) {
        return PredictionResult.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Failed to load history detail');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FoodModel>> getFoods() async {
    try {
      final response = await _dio.get('/stunting/foods?per_page=2000');
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((f) => FoodModel.fromJson(f)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to load foods');
    } catch (e) {
      rethrow;
    }
  }

  Future<AiSupportModel> getCookingGuide(List<String> foodNames) async {
    try {
      final response = await _dio.post('/stunting/gemini/cooking-guide', data: {
        'food_names': foodNames,
      });
      if (response.data['success'] == true) {
        return AiSupportModel.fromJson({'cooking_guide': response.data['data']});
      }
      throw Exception(response.data['message'] ?? 'Failed to load cooking guide');
    } catch (e) {
      rethrow;
    }
  }

  Future<AiSupportModel> getMealPlan(int predictionId) async {
    try {
      final response = await _dio.post('/stunting/gemini/meal-plan', data: {
        'prediction_id': predictionId,
      });
      if (response.data['success'] == true) {
        return AiSupportModel.fromJson({'meal_plan': response.data['data']});
      }
      throw Exception(response.data['message'] ?? 'Failed to load meal plan');
    } catch (e) {
      rethrow;
    }
  }
}
