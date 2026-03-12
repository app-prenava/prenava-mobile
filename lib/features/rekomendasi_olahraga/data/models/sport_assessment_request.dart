class SportAssessmentRequest {
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
  final bool? placentaPositionRestriction;

  SportAssessmentRequest({
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
    this.placentaPositionRestriction,
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
