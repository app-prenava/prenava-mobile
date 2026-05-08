import 'food.dart';

class PredictionSummary {
  final String riskLabel;
  final double probability;

  const PredictionSummary({required this.riskLabel, required this.probability});
}

class RecommendedFood {
  final Food food;
  final bool hasRecipe;
  final String reason;

  const RecommendedFood({
    required this.food,
    required this.hasRecipe,
    required this.reason,
  });
}

class RecommendationBundle {
  final bool cached;
  final bool needsPreferences;
  final String? message;
  final PredictionSummary summary;
  final List<RecommendedFood> foods;
  final List<String> preferenceQuestions;
  final Map<String, dynamic>? aiSupport;
  final Map<String, dynamic>? featureSupport;

  const RecommendationBundle({
    required this.cached,
    required this.needsPreferences,
    this.message,
    required this.summary,
    required this.foods,
    this.preferenceQuestions = const [],
    this.aiSupport,
    this.featureSupport,
  });
}
