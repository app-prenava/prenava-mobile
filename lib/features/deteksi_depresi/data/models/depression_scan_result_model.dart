import '../../domain/entities/depression_scan_result.dart';

class DepressionScanResultModel extends DepressionScanResult {
  const DepressionScanResultModel({
    required super.success,
    required super.faceDetected,
    super.faceConfidence,
    super.score,
    super.level,
    super.disclaimer,
    super.expressionScore,
    super.fatigueScore,
    super.expressionProbabilities,
    super.fatigueProbabilities,
    super.error,
  });

  factory DepressionScanResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data == null) {
      return DepressionScanResultModel(
        success: false,
        faceDetected: false,
        error: json['message'] as String? ?? 'Unknown error',
      );
    }

    final success = data['success'] as bool? ?? false;
    final faceDetected = data['face_detected'] as bool? ?? false;

    if (!success || !faceDetected) {
      return DepressionScanResultModel(
        success: success,
        faceDetected: faceDetected,
        error: data['error'] as String?,
      );
    }

    Map<String, double>? parseProbs(Map<String, dynamic>? raw) {
      if (raw == null) return null;
      return raw.map((k, v) => MapEntry(k, (v as num).toDouble()));
    }

    final expression = data['expression'] as Map<String, dynamic>?;
    final fatigue = data['fatigue'] as Map<String, dynamic>?;

    return DepressionScanResultModel(
      success: true,
      faceDetected: true,
      faceConfidence: (data['face_confidence'] as num?)?.toDouble(),
      score: (data['score'] as num?)?.toDouble(),
      level: data['level'] as String?,
      disclaimer: data['disclaimer'] as String?,
      expressionScore: (expression?['score'] as num?)?.toDouble(),
      fatigueScore: (fatigue?['score'] as num?)?.toDouble(),
      expressionProbabilities:
          parseProbs(expression?['probabilities'] as Map<String, dynamic>?),
      fatigueProbabilities:
          parseProbs(fatigue?['probabilities'] as Map<String, dynamic>?),
    );
  }
}
