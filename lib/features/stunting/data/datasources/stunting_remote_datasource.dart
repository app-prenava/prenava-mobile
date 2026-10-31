import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/core/network/dio_client.dart';
import 'package:prenava_mobile/core/network/stunting_v2_dio_client.dart';
import 'package:prenava_mobile/core/config/env.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

final stuntingRemoteDataSourceProvider =
    Provider<StuntingRemoteDataSource>((ref) {
  return StuntingRemoteDataSource(
    ref.read(appDioProvider),
    Env.useStuntingV2Local ? ref.read(stuntingV2DioProvider) : null,
  );
});

class StuntingRemoteDataSource {
  final Dio dio;
  final Dio? localV2Dio;

  StuntingRemoteDataSource(this.dio, [this.localV2Dio]);

  Dio get _v2Dio {
    final client = localV2Dio;
    if (!Env.useStuntingV2Local || client == null) {
      throw StateError('Stunting V2 local client is not enabled.');
    }
    return client;
  }

  Future<List<StuntingQuestion>> getQuestions() async {
    final response = Env.useStuntingV2Local
        ? await _v2Dio.get('/questions')
        : await dio.get('/stunting/questions');
    final data = response.data['data'] as List;
    return data.map((json) => StuntingQuestion.fromJson(json)).toList();
  }

  Future<PredictionResult> submitPrediction(
      Map<String, dynamic> answers) async {
    if (Env.useStuntingV2Local) {
      final response = await _v2Dio.post('/predict', data: answers);
      return PredictionResult.fromLocalV2(
        response.data as Map<String, dynamic>,
        inputData: answers,
      );
    }
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
