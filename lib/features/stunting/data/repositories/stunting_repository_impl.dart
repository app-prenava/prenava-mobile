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
  Future<PredictionResult> submitPrediction(Map<String, dynamic> inputData) {
    return _remoteDataSource.submitPrediction(inputData);
  }

  @override
  Future<AiMealPlanResponse> generateMealPlan(Map<String, dynamic> data) {
    return _remoteDataSource.generateMealPlan(data);
  }

  @override
  Future<List<StuntingHistoryItem>> getHistory() {
    return _remoteDataSource.getHistory();
  }

  @override
  Future<PredictionResult> getHistoryDetail(int id) {
    return _remoteDataSource.getHistoryDetail(id);
  }
}
