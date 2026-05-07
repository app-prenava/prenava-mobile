import 'package:freezed_annotation/freezed_annotation.dart';

part 'stunting_models.freezed.dart';
part 'stunting_models.g.dart';

@freezed
abstract class StuntingQuestion with _$StuntingQuestion {
  const factory StuntingQuestion({
    required String key,
    required String label,
    required String type,
    required bool required,
    List<StuntingOption>? options,
    double? min,
    double? max,
    String? unit,
  }) = _StuntingQuestion;

  factory StuntingQuestion.fromJson(Map<String, dynamic> json) =>
      _$StuntingQuestionFromJson(json);
}

@freezed
abstract class StuntingOption with _$StuntingOption {
  const factory StuntingOption({
    required dynamic value,
    required String label,
  }) = _StuntingOption;

  factory StuntingOption.fromJson(Map<String, dynamic> json) =>
      _$StuntingOptionFromJson(json);
}

@freezed
abstract class ShapFactor with _$ShapFactor {
  const factory ShapFactor({
    required String feature,
    required String impact,
    required double value,
    String? message,
  }) = _ShapFactor;

  factory ShapFactor.fromJson(Map<String, dynamic> json) =>
      _$ShapFactorFromJson(json);
}

@freezed
abstract class ShapExplanation with _$ShapExplanation {
  const factory ShapExplanation({
    required String method,
    @JsonKey(name: 'top_factors') required List<ShapFactor> topFactors,
  }) = _ShapExplanation;

  factory ShapExplanation.fromJson(Map<String, dynamic> json) =>
      _$ShapExplanationFromJson(json);
}

@freezed
abstract class PredictionResult with _$PredictionResult {
  const factory PredictionResult({
    required int id,
    @JsonKey(name: 'risk_label') required String riskLabel,
    required double probability,
    @JsonKey(name: 'prediction') required int predictionValue,
    ShapExplanation? explanation,
    @JsonKey(name: 'model_version') String? modelVersion,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _PredictionResult;

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      _$PredictionResultFromJson(json);
}

@freezed
abstract class FoodModel with _$FoodModel {
  const factory FoodModel({
    required int id,
    required String name,
    @JsonKey(name: 'image_url') String? imageUrl,
    required double protein,
    required double calories,
    double? fat,
    double? carbohydrates,
    String? reason,
  }) = _FoodModel;

  factory FoodModel.fromJson(Map<String, dynamic> json) =>
      _$FoodModelFromJson(json);
}

@freezed
abstract class AiSupportModel with _$AiSupportModel {
  const factory AiSupportModel({
    @JsonKey(name: 'cooking_guide') String? cookingGuide,
    @JsonKey(name: 'nutrition_tips') String? nutritionTips,
    @JsonKey(name: 'meal_plan') String? mealPlan,
  }) = _AiSupportModel;

  factory AiSupportModel.fromJson(Map<String, dynamic> json) =>
      _$AiSupportModelFromJson(json);
}

@freezed
abstract class RecommendationResponse with _$RecommendationResponse {
  const factory RecommendationResponse({
    required bool success,
    required bool cached,
    required RecommendationData data,
  }) = _RecommendationResponse;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseFromJson(json);
}

@freezed
abstract class RecommendationData with _$RecommendationData {
  const factory RecommendationData({
    @JsonKey(name: 'prediction_summary') required PredictionSummary predictionSummary,
    @JsonKey(name: 'recommended_foods') required List<FoodModel> recommendedFoods,
    @JsonKey(name: 'ai_support') AiSupportModel? aiSupport,
  }) = _RecommendationData;

  factory RecommendationData.fromJson(Map<String, dynamic> json) =>
      _$RecommendationDataFromJson(json);
}

@freezed
abstract class PredictionSummary with _$PredictionSummary {
  const factory PredictionSummary({
    @JsonKey(name: 'risk_label') required String riskLabel,
    required double probability,
  }) = _PredictionSummary;

  factory PredictionSummary.fromJson(Map<String, dynamic> json) =>
      _$PredictionSummaryFromJson(json);
}

@freezed
abstract class StuntingHistoryItem with _$StuntingHistoryItem {
  const factory StuntingHistoryItem({
    required int id,
    @JsonKey(name: 'risk_label') required String riskLabel,
    required double probability,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _StuntingHistoryItem;

  factory StuntingHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$StuntingHistoryItemFromJson(json);
}
