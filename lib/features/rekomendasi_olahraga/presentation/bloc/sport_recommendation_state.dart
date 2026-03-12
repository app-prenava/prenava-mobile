import 'package:equatable/equatable.dart';
import '../../data/models/sport_recommendation_response.dart';

abstract class SportRecommendationState extends Equatable {
  const SportRecommendationState();

  @override
  List<Object?> get props => [];
}

class SportRecommendationInitial extends SportRecommendationState {}

class SportRecommendationLoading extends SportRecommendationState {}

class SportRecommendationError extends SportRecommendationState {
  final String message;
  const SportRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}

// 422 Error: DOB missing. Navigate to Complete Profile.
class SportRecommendationNeedsProfile extends SportRecommendationState {
  final String message;
  const SportRecommendationNeedsProfile(this.message);
  @override
  List<Object?> get props => [message];
}

// 404 Error: LMP Missing. Show Bottom Sheet 1.
class SportRecommendationNeedsLmp extends SportRecommendationState {
  final String message;
  const SportRecommendationNeedsLmp(this.message);
  @override
  List<Object?> get props => [message];
}

// 404 Error: Assessment Missing. Show Bottom Sheet 2.
class SportRecommendationNeedsAssessment extends SportRecommendationState {
  final String message;
  const SportRecommendationNeedsAssessment(this.message);
  @override
  List<Object?> get props => [message];
}

// Success Status -> Display Recommendations.
// If needUpdateData is true, we should also emit a flag to show Bottom Sheet 2 before or during rendering.
class SportRecommendationLoaded extends SportRecommendationState {
  final SportRecommendationResponse response;
  final bool showUpdateAssessmentPrompt;

  const SportRecommendationLoaded(this.response, {this.showUpdateAssessmentPrompt = false});

  @override
  List<Object?> get props => [response, showUpdateAssessmentPrompt];
}
