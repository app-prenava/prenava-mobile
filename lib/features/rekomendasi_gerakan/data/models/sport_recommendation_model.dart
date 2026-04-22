import '../../domain/entities/sport_recommendation.dart';

class SportRecommendationModel extends SportRecommendation {
  const SportRecommendationModel({
    required super.activity,
    required super.score,
    super.videoLink,
    super.longText,
    super.picture1,
    super.picture2,
    super.picture3,
  });

  factory SportRecommendationModel.fromJson(Map<String, dynamic> json) {
    return SportRecommendationModel(
      activity: json['activity'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      videoLink: json['video_link'],
      longText: json['long_text'],
      picture1: json['picture_1'],
      picture2: json['picture_2'],
      picture3: json['picture_3'],
    );
  }
}

class SportRecommendationResponseModel extends SportRecommendationResponse {
  const SportRecommendationResponseModel({
    required super.status,
    required super.message,
    super.needUpdateData,
    required super.recommendations,
  });

  factory SportRecommendationResponseModel.fromJson(Map<String, dynamic> json) {
    bool? needUpdate = json['need_update_data'];

    // Parse model_response.recommendations
    List<SportRecommendation> parsedRecommendations = [];
    if (json['model_response'] != null &&
        json['model_response']['recommendations'] != null) {
      final recs = json['model_response']['recommendations'] as List;
      parsedRecommendations = recs
          .map(
            (e) => SportRecommendationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    return SportRecommendationResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      needUpdateData: needUpdate,
      recommendations: parsedRecommendations,
    );
  }
}

class SportAssessmentPayloadModel extends SportAssessmentPayload {
  const SportAssessmentPayloadModel({
    required super.bmi,
    required super.hypertension,
    required super.isDiabetes,
    required super.gestationalDiabetes,
    required super.isFever,
    required super.isHighHeartRate,
    required super.previousComplications,
    required super.mentalHealthIssue,
    required super.lowImpactPref,
    required super.waterAccess,
    required super.backPain,
    required super.placentaPositionRestriction,
  });

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'hypertension': hypertension,
      'is_diabetes': isDiabetes,
      'gestational_diabetes': gestationalDiabetes,
      'is_fever': isFever,
      'is_high_heart_rate': isHighHeartRate,
      'previous_complications': previousComplications,
      'mental_health_issue': mentalHealthIssue,
      'low_impact_pref': lowImpactPref,
      'water_access': waterAccess,
      'back_pain': backPain,
      'placenta_position_restriction': placentaPositionRestriction,
    };
  }
}
