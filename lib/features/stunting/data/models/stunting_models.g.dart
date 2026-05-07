// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stunting_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StuntingQuestion _$StuntingQuestionFromJson(Map<String, dynamic> json) =>
    _StuntingQuestion(
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      required: json['required'] as bool,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => StuntingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$StuntingQuestionToJson(_StuntingQuestion instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'type': instance.type,
      'required': instance.required,
      'options': instance.options,
      'min': instance.min,
      'max': instance.max,
      'unit': instance.unit,
    };

_StuntingOption _$StuntingOptionFromJson(Map<String, dynamic> json) =>
    _StuntingOption(value: json['value'], label: json['label'] as String);

Map<String, dynamic> _$StuntingOptionToJson(_StuntingOption instance) =>
    <String, dynamic>{'value': instance.value, 'label': instance.label};

_ShapFactor _$ShapFactorFromJson(Map<String, dynamic> json) => _ShapFactor(
  feature: json['feature'] as String,
  impact: json['impact'] as String,
  value: (json['value'] as num).toDouble(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ShapFactorToJson(_ShapFactor instance) =>
    <String, dynamic>{
      'feature': instance.feature,
      'impact': instance.impact,
      'value': instance.value,
      'message': instance.message,
    };

_ShapExplanation _$ShapExplanationFromJson(Map<String, dynamic> json) =>
    _ShapExplanation(
      method: json['method'] as String,
      topFactors: (json['top_factors'] as List<dynamic>)
          .map((e) => ShapFactor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShapExplanationToJson(_ShapExplanation instance) =>
    <String, dynamic>{
      'method': instance.method,
      'top_factors': instance.topFactors,
    };

_PredictionResult _$PredictionResultFromJson(Map<String, dynamic> json) =>
    _PredictionResult(
      id: (json['id'] as num).toInt(),
      riskLabel: json['risk_label'] as String,
      probability: (json['probability'] as num).toDouble(),
      predictionValue: (json['prediction'] as num).toInt(),
      explanation: json['explanation'] == null
          ? null
          : ShapExplanation.fromJson(
              json['explanation'] as Map<String, dynamic>,
            ),
      modelVersion: json['model_version'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$PredictionResultToJson(_PredictionResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'risk_label': instance.riskLabel,
      'probability': instance.probability,
      'prediction': instance.predictionValue,
      'explanation': instance.explanation,
      'model_version': instance.modelVersion,
      'created_at': instance.createdAt,
    };

_FoodModel _$FoodModelFromJson(Map<String, dynamic> json) => _FoodModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  imageUrl: json['image_url'] as String?,
  protein: (json['protein'] as num).toDouble(),
  calories: (json['calories'] as num).toDouble(),
  fat: (json['fat'] as num?)?.toDouble(),
  carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$FoodModelToJson(_FoodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'protein': instance.protein,
      'calories': instance.calories,
      'fat': instance.fat,
      'carbohydrates': instance.carbohydrates,
      'reason': instance.reason,
    };

_AiSupportModel _$AiSupportModelFromJson(Map<String, dynamic> json) =>
    _AiSupportModel(
      cookingGuide: json['cooking_guide'] as String?,
      nutritionTips: json['nutrition_tips'] as String?,
      mealPlan: json['meal_plan'] as String?,
    );

Map<String, dynamic> _$AiSupportModelToJson(_AiSupportModel instance) =>
    <String, dynamic>{
      'cooking_guide': instance.cookingGuide,
      'nutrition_tips': instance.nutritionTips,
      'meal_plan': instance.mealPlan,
    };

_RecommendationResponse _$RecommendationResponseFromJson(
  Map<String, dynamic> json,
) => _RecommendationResponse(
  success: json['success'] as bool,
  cached: json['cached'] as bool,
  data: RecommendationData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RecommendationResponseToJson(
  _RecommendationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'cached': instance.cached,
  'data': instance.data,
};

_RecommendationData _$RecommendationDataFromJson(Map<String, dynamic> json) =>
    _RecommendationData(
      predictionSummary: PredictionSummary.fromJson(
        json['prediction_summary'] as Map<String, dynamic>,
      ),
      recommendedFoods: (json['recommended_foods'] as List<dynamic>)
          .map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiSupport: json['ai_support'] == null
          ? null
          : AiSupportModel.fromJson(json['ai_support'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecommendationDataToJson(_RecommendationData instance) =>
    <String, dynamic>{
      'prediction_summary': instance.predictionSummary,
      'recommended_foods': instance.recommendedFoods,
      'ai_support': instance.aiSupport,
    };

_PredictionSummary _$PredictionSummaryFromJson(Map<String, dynamic> json) =>
    _PredictionSummary(
      riskLabel: json['risk_label'] as String,
      probability: (json['probability'] as num).toDouble(),
    );

Map<String, dynamic> _$PredictionSummaryToJson(_PredictionSummary instance) =>
    <String, dynamic>{
      'risk_label': instance.riskLabel,
      'probability': instance.probability,
    };

_StuntingHistoryItem _$StuntingHistoryItemFromJson(Map<String, dynamic> json) =>
    _StuntingHistoryItem(
      id: (json['id'] as num).toInt(),
      riskLabel: json['risk_label'] as String,
      probability: (json['probability'] as num).toDouble(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$StuntingHistoryItemToJson(
  _StuntingHistoryItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'risk_label': instance.riskLabel,
  'probability': instance.probability,
  'created_at': instance.createdAt,
};
