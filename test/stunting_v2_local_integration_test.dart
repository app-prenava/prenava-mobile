import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prenava_mobile/core/config/env.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

const payload = <String, dynamic>{
  'child_gender': 1,
  'age_in_months': 18,
  'child_weight_kg': 9.5,
  'mother_education_level': 3,
  'mother_employment_status': 1,
  'mother_height_cm': 153.0,
  'improved_water': 1,
  'improved_sanitation': 1,
  'home_ownership': 1,
  'has_electricity': 1,
  'has_refrigerator': 0,
  'has_tv': 1,
  'maternal_miscarriages': 0,
  'maternal_parity': 2,
  'maternal_bmi': 22.0,
  'maternal_hemoglobin': 12.0,
  'child_birth_weight': 3.0,
  'child_breastfed': 1,
  'maternal_anc_visits': 6,
  'child_had_diarrhea': 0,
  'child_had_ari': 0,
  'hh_food_expenditure_weekly': 500000.0,
  'mother_age_at_birth': 27.0,
  'has_delivery_insurance': 1,
  'anc_clinic_midwife': 1,
  'anc_hospital': 0,
  'anc_traditional_other': 0,
  'anc_unknown': 0,
};

void main() {
  test(
    'Flutter Dio contract reaches the local V2 API',
    () async {
      final dio = Dio(BaseOptions(baseUrl: Env.stuntingV2LocalApiBase));

      final health = await dio.get<Map<String, dynamic>>('/health');
      expect(health.data?['status'], 'ready_for_local_testing');
      expect(health.data?['production_ready'], isFalse);

      final questions = await dio.get<Map<String, dynamic>>('/questions');
      expect(questions.data?['data'], isA<List<dynamic>>());
      expect((questions.data?['data'] as List<dynamic>).length, 28);

      final response = await dio.post<Map<String, dynamic>>(
        '/predict',
        data: payload,
      );
      final result = PredictionResult.fromLocalV2(
        response.data!,
        inputData: payload,
      );
      expect(result.localOnly, isTrue);
      expect(result.productionReady, isFalse);
      expect(result.modelStatus, 'FAIL_LOCAL_5B');
      expect(result.ageBand, '12-23');
    },
    skip: !Env.useStuntingV2Local,
  );
}
