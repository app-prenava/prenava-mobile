import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

abstract class StuntingRepository {
  Future<List<StuntingQuestion>> getQuestions();
  Future<PredictionResult> predict(Map<String, dynamic> inputData);
  Future<RecommendationResponse> getRecommendations(int predictionId);
  Future<List<StuntingHistoryItem>> getHistory();
  Future<PredictionResult> getHistoryDetail(int id);
  Future<List<FoodModel>> getFoods();
  Future<AiSupportModel> getCookingGuide(List<String> foodNames);
  Future<AiSupportModel> getMealPlan(int predictionId);
}
