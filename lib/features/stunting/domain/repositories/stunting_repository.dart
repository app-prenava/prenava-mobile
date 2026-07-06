import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

abstract class StuntingRepository {
  Future<List<StuntingQuestion>> getQuestions();
  Future<PredictionResult> submitPrediction(Map<String, dynamic> inputData);
  Future<AiMealPlanResponse> generateMealPlan(Map<String, dynamic> data);
  Future<List<StuntingHistoryItem>> getHistory();
  Future<PredictionResult> getHistoryDetail(int id);
}
