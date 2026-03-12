import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prenava/features/rekomendasi_olahraga/data/models/sport_assessment_request.dart';
import 'package:prenava/features/rekomendasi_olahraga/data/models/sport_recommendation_response.dart';
import '../../../../core/network/api_client.dart';

abstract class SportRecommendationRemoteDataSource {
  Future<SportRecommendationResponse> getSportRecommendation();
  Future<SportRecommendationResponse> createSportRecommendation(SportAssessmentRequest request);
}

class SportRecommendationRemoteDataSourceImpl implements SportRecommendationRemoteDataSource {
  final ApiClient client;

  SportRecommendationRemoteDataSourceImpl({required this.client});

  @override
  Future<SportRecommendationResponse> getSportRecommendation() async {
    final response = await client.get('/ibu-hamil/sport-recommendation');
    final responseBody = json.decode(response.body);

    // We pass the raw response even on errors to let the Repository/Bloc handle 422, 404, etc.
    return SportRecommendationResponse.fromJson(responseBody);
  }

  @override
  Future<SportRecommendationResponse> createSportRecommendation(SportAssessmentRequest request) async {
    final response = await client.post('/ibu-hamil/sport-recommendation', body: request.toJson());
    final responseBody = json.decode(response.body);
    
    return SportRecommendationResponse.fromJson(responseBody);
  }
}
