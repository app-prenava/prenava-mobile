import '../../domain/entities/sport_recommendation.dart';
import '../../domain/repositories/sport_recommendation_repository.dart';
import '../datasources/sport_recommendation_remote_datasource.dart';
import '../models/sport_recommendation_model.dart';

class SportRecommendationRepositoryImpl
    implements SportRecommendationRepository {
  final SportRecommendationRemoteDatasource _datasource;

  SportRecommendationRepositoryImpl(this._datasource);

  @override
  Future<SportRecommendationResponse> getRecommendations() async {
    return await _datasource.getRecommendations();
  }

  @override
  Future<SportRecommendationResponse> createRecommendation(
    SportAssessmentPayload payload,
  ) async {
    final model = SportAssessmentPayloadModel(
      bmi: payload.bmi,
      hypertension: payload.hypertension,
      isDiabetes: payload.isDiabetes,
      gestationalDiabetes: payload.gestationalDiabetes,
      isFever: payload.isFever,
      isHighHeartRate: payload.isHighHeartRate,
      previousComplications: payload.previousComplications,
      mentalHealthIssue: payload.mentalHealthIssue,
      lowImpactPref: payload.lowImpactPref,
      waterAccess: payload.waterAccess,
      backPain: payload.backPain,
      placentaPositionRestriction: payload.placentaPositionRestriction,
    );
    return await _datasource.createRecommendation(model.toJson());
  }

  @override
  Future<List<SportRecommendation>> getAllSports() async {
    return await _datasource.getAllSports();
  }

  @override
  Future<Map<String, dynamic>?> getExistingAssessment() async {
    return await _datasource.getExistingAssessment();
  }
}
