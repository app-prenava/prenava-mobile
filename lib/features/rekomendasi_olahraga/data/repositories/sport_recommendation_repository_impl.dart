import 'package:fpdart/fpdart.dart';
import 'package:prenava_mobile/core/error/failures.dart';
import 'package:prenava_mobile/features/rekomendasi_olahraga/data/datasources/sport_recommendation_remote_data_source.dart';
import 'package:prenava_mobile/features/rekomendasi_olahraga/data/models/sport_assessment_request.dart';
import 'package:prenava_mobile/features/rekomendasi_olahraga/data/models/sport_recommendation_response.dart';
import 'package:prenava_mobile/features/rekomendasi_olahraga/domain/repositories/sport_recommendation_repository.dart';

class SportRecommendationRepositoryImpl implements SportRecommendationRepository {
  final SportRecommendationRemoteDataSource remoteDataSource;

  SportRecommendationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SportRecommendationResponse>> getSportRecommendation() async {
    try {
      final response = await remoteDataSource.getSportRecommendation();
      
      // We check the application-level status from the JSON wrapper, 
      // or we can just return it and let the Bloc decide based on the message.
      if (response.status == 'error') {
         return Left(ServerFailure(response.message));
      }
      return Right(response);
    } catch (e) {
      // For actual HTTP errors (404, 422), our api_client usually parses them.
      // But we will catch specific strings from the message down the line.
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, SportRecommendationResponse>> createSportRecommendation(SportAssessmentRequest request) async {
    try {
      final response = await remoteDataSource.createSportRecommendation(request);
      if (response.status == 'error') {
         return Left(ServerFailure(response.message));
      }
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
