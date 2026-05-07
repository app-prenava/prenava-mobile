import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/features/stunting/data/datasources/stunting_remote_datasource.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/domain/repositories/stunting_repository.dart';

final stuntingRepositoryProvider = Provider<StuntingRepository>((ref) {
  final remoteDataSource = ref.watch(stuntingRemoteDataSourceProvider);
  return StuntingRepositoryImpl(remoteDataSource);
});

class StuntingRepositoryImpl implements StuntingRepository {
  final StuntingRemoteDataSource _remoteDataSource;

  StuntingRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<StuntingQuestion>> getQuestions() {
    return _remoteDataSource.getQuestions();
  }

  @override
  Future<PredictionResult> predict(Map<String, dynamic> inputData) {
    return _remoteDataSource.predict(inputData);
  }

  @override
  Future<RecommendationResponse> getRecommendations(int predictionId) {
    return _remoteDataSource.getRecommendations(predictionId);
  }

  @override
  Future<List<StuntingHistoryItem>> getHistory() {
    return _remoteDataSource.getHistory();
  }

  @override
  Future<PredictionResult> getHistoryDetail(int id) {
    return _remoteDataSource.getHistoryDetail(id);
  }

  @override
  Future<List<FoodModel>> getFoods() {
    return _remoteDataSource.getFoods();
  }

  @override
  Future<AiSupportModel> getCookingGuide(List<String> foodNames) {
    return _remoteDataSource.getCookingGuide(foodNames);
  }

  @override
  Future<AiSupportModel> getMealPlan(int predictionId) {
    return _remoteDataSource.getMealPlan(predictionId);
  }
}
