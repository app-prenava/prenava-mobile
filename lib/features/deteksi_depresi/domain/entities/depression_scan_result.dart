class DepressionScanResult {
  final bool success;
  final bool faceDetected;
  final double? faceConfidence;
  final double? score;
  final String? level;
  final String? disclaimer;
  final double? expressionScore;
  final double? fatigueScore;
  final Map<String, double>? expressionProbabilities;
  final Map<String, double>? fatigueProbabilities;
  final String? error;

  const DepressionScanResult({
    required this.success,
    required this.faceDetected,
    this.faceConfidence,
    this.score,
    this.level,
    this.disclaimer,
    this.expressionScore,
    this.fatigueScore,
    this.expressionProbabilities,
    this.fatigueProbabilities,
    this.error,
  });

  /// Wellbeing score is the inverse of depression score (higher = healthier)
  double get wellbeingScore => score != null ? (100.0 - score!) : 0.0;
}
