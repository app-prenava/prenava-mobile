class SportRecommendation {
  final String activity;
  final double score;
  final String? videoLink;
  final String? longText;
  final String? picture1;
  final String? picture2;
  final String? picture3;

  const SportRecommendation({
    required this.activity,
    required this.score,
    this.videoLink,
    this.longText,
    this.picture1,
    this.picture2,
    this.picture3,
  });
}

class SportRecommendationResponse {
  final String status;
  final String message;
  final bool? needUpdateData;
  final List<SportRecommendation> recommendations;

  const SportRecommendationResponse({
    required this.status,
    required this.message,
    this.needUpdateData,
    required this.recommendations,
  });
}

class SportAssessmentPayload {
  final double bmi;
  final bool hypertension;
  final bool isDiabetes;
  final bool gestationalDiabetes;
  final bool isFever;
  final bool isHighHeartRate;
  final bool previousComplications;
  final bool mentalHealthIssue;
  final bool lowImpactPref;
  final bool waterAccess;
  final bool backPain;
  final bool placentaPositionRestriction;

  const SportAssessmentPayload({
    required this.bmi,
    required this.hypertension,
    required this.isDiabetes,
    required this.gestationalDiabetes,
    required this.isFever,
    required this.isHighHeartRate,
    required this.previousComplications,
    required this.mentalHealthIssue,
    required this.lowImpactPref,
    required this.waterAccess,
    required this.backPain,
    required this.placentaPositionRestriction,
  });
}
