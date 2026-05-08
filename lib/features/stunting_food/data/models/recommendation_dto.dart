import '../../domain/entities/recommendation.dart';
import 'food_dto.dart';

class RecommendationDto {
  final bool cached;
  final bool needsPreferences;
  final String? message;
  final PredictionSummary summary;
  final List<RecommendedFood> foods;
  final List<String> preferenceQuestions;
  final Map<String, dynamic>? aiSupport;
  final Map<String, dynamic>? featureSupport;

  const RecommendationDto({
    required this.cached,
    required this.needsPreferences,
    this.message,
    required this.summary,
    required this.foods,
    this.preferenceQuestions = const [],
    this.aiSupport,
    this.featureSupport,
  });

  factory RecommendationDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawSummary =
        data['prediction_summary'] as Map<String, dynamic>? ?? const {};
    final rawFoods = (data['recommended_foods'] as List?) ?? const [];
    final questions = (data['preference_questions'] as List? ?? const [])
        .map((e) {
          if (e is Map) {
            return e['question']?.toString() ??
                e['label']?.toString() ??
                e.toString();
          }
          return e.toString();
        })
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return RecommendationDto(
      cached: json['cached'] == true,
      needsPreferences: json['needs_preferences'] == true,
      message: json['message']?.toString(),
      summary: PredictionSummary(
        riskLabel: rawSummary['risk_label']?.toString() ?? 'low_risk',
        probability: ((rawSummary['probability'] as num?) ?? 0).toDouble(),
      ),
      foods: rawFoods
          .whereType<Map<String, dynamic>>()
          .map(
            (f) => RecommendedFood(
              food: FoodDto.fromJson(f).toEntity(),
              hasRecipe: f['has_recipe'] == true,
              reason: f['reason']?.toString() ?? '-',
            ),
          )
          .toList(),
      preferenceQuestions: questions,
      aiSupport: data['ai_support'] as Map<String, dynamic>?,
      featureSupport: data['feature_support'] as Map<String, dynamic>?,
    );
  }

  RecommendationBundle toEntity() => RecommendationBundle(
    cached: cached,
    needsPreferences: needsPreferences,
    message: message,
    summary: summary,
    foods: foods,
    preferenceQuestions: preferenceQuestions,
    aiSupport: aiSupport,
    featureSupport: featureSupport,
  );
}
