import 'package:equatable/equatable.dart';
import 'package:prenava/features/rekomendasi_olahraga/data/models/sport_assessment_request.dart';

abstract class SportRecommendationEvent extends Equatable {
  const SportRecommendationEvent();

  @override
  List<Object?> get props => [];
}

class GetSportRecommendationEvent extends SportRecommendationEvent {}

class SubmitSportAssessmentEvent extends SportRecommendationEvent {
  final SportAssessmentRequest request;

  const SubmitSportAssessmentEvent(this.request);

  @override
  List<Object?> get props => [request];
}
