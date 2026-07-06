import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/core/network/dio_client.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

final stuntingRemoteDataSourceProvider = Provider<StuntingRemoteDataSource>((ref) {
  return StuntingRemoteDataSource(ref.read(appDioProvider));
});

class StuntingRemoteDataSource {
  final Dio dio;
  StuntingRemoteDataSource(this.dio);

  Future<List<StuntingQuestion>> getQuestions() async {
    final response = await dio.get('/stunting/questions');
    final data = response.data['data'] as List;
    return data.map((json) => StuntingQuestion.fromJson(json)).toList();
  }

  Future<PredictionResult> submitPrediction(Map<String, dynamic> answers) async {
    final response = await dio.post('/stunting/predict', data: answers);
    return PredictionResult.fromJson(response.data['data']);
  }

  Future<List<StuntingHistoryItem>> getHistory() async {
    final response = await dio.get('/stunting/history');
    final data = response.data['data'] as List;
    return data.map((json) => StuntingHistoryItem.fromJson(json)).toList();
  }
  
  Future<AiMealPlanResponse> generateMealPlan(Map<String, dynamic> data) async {
    final response = await dio.post('/user/meal-plan/generate', data: data);
    return AiMealPlanResponse.fromJson(response.data['data']);
  }

  Future<PredictionResult> getHistoryDetail(int id) async {
    final response = await dio.get('/stunting/history/$id');
    return PredictionResult.fromJson(response.data['data']);
  }
}
