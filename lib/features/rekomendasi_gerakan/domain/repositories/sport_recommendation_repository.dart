import '../entities/sport_recommendation.dart';

abstract class SportRecommendationRepository {
  Future<SportRecommendationResponse> getRecommendations();
  Future<SportRecommendationResponse> createRecommendation(
    SportAssessmentPayload payload,
  );
  Future<List<SportRecommendation>> getAllSports();
}
