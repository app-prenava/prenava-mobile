import '../../domain/entities/sport_recommendation.dart';

class SportRecommendationModel extends SportRecommendation {
  const SportRecommendationModel({
    required super.code,
    required super.name,
    required super.category,
    required super.recommendationLevel,
    super.videoLink,
    super.longText,
    super.picture1,
    super.picture2,
    super.picture3,
  });

  factory SportRecommendationModel.fromJson(Map<String, dynamic> json) {
    return SportRecommendationModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      recommendationLevel: json['recommendation_level'] ?? '',
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
    required super.highlyRecommended,
    required super.allowedWithCaution,
    required super.avoid,
    required super.all,
  });

  factory SportRecommendationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final recommendationMap =
        json['recommendations'] as Map<String, dynamic>? ?? {};

    List<SportRecommendation> parseList(String key) {
      final data = recommendationMap[key];

      if (data is! List) return [];

      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => SportRecommendationModel.fromJson(e))
          .toList();
    }

    final highlyRecommended = parseList('highly_recommended');
    final allowedWithCaution = parseList('allowed_with_caution');
    final avoid = parseList('avoid');

    final processedAll = [
      ...highlyRecommended,
      ...allowedWithCaution,
      ...avoid,
    ];

    return SportRecommendationResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      needUpdateData: json['need_update_data'] ?? false,
      recommendations: processedAll,
      highlyRecommended: highlyRecommended,
      allowedWithCaution: allowedWithCaution,
      avoid: avoid,
      all: processedAll,
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