import 'package:flutter_test/flutter_test.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

void main() {
  test('local V2 response maps to safe mobile result', () {
    final result = PredictionResult.fromLocalV2(
      {
        'prediction': 1,
        'probability': 0.465969,
        'threshold': 0.285,
        'age_band': '12-23',
        'model_status': 'FAIL_LOCAL_5B',
        'local_only': true,
        'production_ready': false,
        'warnings': ['Do not use in production.'],
      },
      inputData: {'child_weight_kg': 9.5},
    );

    expect(result.riskLevel, 1);
    expect(result.riskLabel, 'Risiko Tinggi');
    expect(result.score, closeTo(0.465969, 0.000001));
    expect(result.localOnly, isTrue);
    expect(result.productionReady, isFalse);
    expect(result.modelStatus, 'FAIL_LOCAL_5B');
    expect(result.ageBand, '12-23');
    expect(result.threshold, 0.285);
    expect(result.predictionId, 0);
  });

  test('question metadata keeps required flag and numeric bounds', () {
    final question = StuntingQuestion.fromJson({
      'key': 'child_weight_kg',
      'label': 'Berat Badan Anak Saat Ini',
      'type': 'number',
      'required': true,
      'min': 0,
      'max': 40,
      'unit': 'kg',
    });

    expect(question.key, 'child_weight_kg');
    expect(question.isRequired, isTrue);
    expect(question.min, 0);
    expect(question.max, 40);
  });
}
