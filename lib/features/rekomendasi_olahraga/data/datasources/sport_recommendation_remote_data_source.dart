import 'package:dio/dio.dart';
import 'package:prenava_mobile/features/rekomendasi_olahraga/data/models/sport_assessment_request.dart';
import 'package:prenava_mobile/features/rekomendasi_olahraga/data/models/sport_recommendation_response.dart';

abstract class SportRecommendationRemoteDataSource {
  Future<SportRecommendationResponse> getSportRecommendation();
  Future<SportRecommendationResponse> createSportRecommendation(SportAssessmentRequest request);
}

class SportRecommendationRemoteDataSourceImpl implements SportRecommendationRemoteDataSource {
  final Dio dio;

  SportRecommendationRemoteDataSourceImpl({required this.dio});

  @override
  Future<SportRecommendationResponse> getSportRecommendation() async {
    try {
      final response = await dio.get('/ibu-hamil/sport-recommendation');
      return SportRecommendationResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return SportRecommendationResponse.fromJson(e.response!.data);
      }
      rethrow;
    }
  }

  @override
  Future<SportRecommendationResponse> createSportRecommendation(SportAssessmentRequest request) async {
    try {
      final response = await dio.post('/ibu-hamil/sport-recommendation', data: request.toJson());
      return SportRecommendationResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        return SportRecommendationResponse.fromJson(e.response!.data);
      }
      rethrow;
    }
  }
}
