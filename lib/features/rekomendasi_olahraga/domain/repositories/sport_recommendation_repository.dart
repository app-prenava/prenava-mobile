import 'package:fpdart/fpdart.dart';
import 'package:prenava/core/error/failures.dart';
import 'package:prenava/features/rekomendasi_olahraga/data/models/sport_assessment_request.dart';
import 'package:prenava/features/rekomendasi_olahraga/data/models/sport_recommendation_response.dart';

abstract class SportRecommendationRepository {
  Future<Either<Failure, SportRecommendationResponse>> getSportRecommendation();
  Future<Either<Failure, SportRecommendationResponse>> createSportRecommendation(SportAssessmentRequest request);
}
