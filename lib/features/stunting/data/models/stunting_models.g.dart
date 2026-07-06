// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stunting_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StuntingQuestionImpl _$$StuntingQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$StuntingQuestionImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      isRequired: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => StuntingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$StuntingQuestionImplToJson(
        _$StuntingQuestionImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'type': instance.type,
      'required': instance.isRequired,
      'options': instance.options,
      'min': instance.min,
      'max': instance.max,
      'unit': instance.unit,
    };

_$StuntingOptionImpl _$$StuntingOptionImplFromJson(Map<String, dynamic> json) =>
    _$StuntingOptionImpl(
      value: json['value'],
      label: json['label'] as String,
    );

Map<String, dynamic> _$$StuntingOptionImplToJson(
        _$StuntingOptionImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
    };

_$ShapFactorImpl _$$ShapFactorImplFromJson(Map<String, dynamic> json) =>
    _$ShapFactorImpl(
      feature: json['feature'] as String,
      impact: json['impact'] as String,
      value: (json['value'] as num).toDouble(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ShapFactorImplToJson(_$ShapFactorImpl instance) =>
    <String, dynamic>{
      'feature': instance.feature,
      'impact': instance.impact,
      'value': instance.value,
      'message': instance.message,
    };

_$ShapExplanationImpl _$$ShapExplanationImplFromJson(
        Map<String, dynamic> json) =>
    _$ShapExplanationImpl(
      method: json['method'] as String,
      topFactors: (json['top_factors'] as List<dynamic>)
          .map((e) => ShapFactor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ShapExplanationImplToJson(
        _$ShapExplanationImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'top_factors': instance.topFactors,
    };

_$PredictionResultImpl _$$PredictionResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PredictionResultImpl(
      predictionId: (json['predictionId'] as num).toInt(),
      riskLabel: json['riskLabel'] as String,
      score: (json['score'] as num).toDouble(),
      riskLevel: (json['riskLevel'] as num).toInt(),
      recommendation: json['recommendation'] as String,
      explanation: json['explanation'] == null
          ? null
          : ShapExplanation.fromJson(
              json['explanation'] as Map<String, dynamic>),
      inputData: json['inputData'] as Map<String, dynamic>?,
      aiMealPlan: json['aiMealPlan'] == null
          ? null
          : AiMealPlanResponse.fromJson(
              json['aiMealPlan'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PredictionResultImplToJson(
        _$PredictionResultImpl instance) =>
    <String, dynamic>{
      'predictionId': instance.predictionId,
      'riskLabel': instance.riskLabel,
      'score': instance.score,
      'riskLevel': instance.riskLevel,
      'recommendation': instance.recommendation,
      'explanation': instance.explanation,
      'inputData': instance.inputData,
      'aiMealPlan': instance.aiMealPlan,
    };

_$FoodModelImpl _$$FoodModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      protein: (json['protein'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$FoodModelImplToJson(_$FoodModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'protein': instance.protein,
      'calories': instance.calories,
      'fat': instance.fat,
      'carbohydrates': instance.carbohydrates,
      'reason': instance.reason,
    };

_$AiSupportModelImpl _$$AiSupportModelImplFromJson(Map<String, dynamic> json) =>
    _$AiSupportModelImpl(
      cookingGuide: json['cooking_guide'] as String?,
      nutritionTips: json['nutrition_tips'] as String?,
      mealPlan: json['meal_plan'] as String?,
    );

Map<String, dynamic> _$$AiSupportModelImplToJson(
        _$AiSupportModelImpl instance) =>
    <String, dynamic>{
      'cooking_guide': instance.cookingGuide,
      'nutrition_tips': instance.nutritionTips,
      'meal_plan': instance.mealPlan,
    };

_$RecommendationResponseImpl _$$RecommendationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationResponseImpl(
      success: json['success'] as bool,
      cached: json['cached'] as bool,
      data: RecommendationData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RecommendationResponseImplToJson(
        _$RecommendationResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'cached': instance.cached,
      'data': instance.data,
    };

_$RecommendationDataImpl _$$RecommendationDataImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationDataImpl(
      predictionSummary: PredictionSummary.fromJson(
          json['prediction_summary'] as Map<String, dynamic>),
      recommendedFoods: (json['recommended_foods'] as List<dynamic>)
          .map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiSupport: json['ai_support'] == null
          ? null
          : AiSupportModel.fromJson(json['ai_support'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RecommendationDataImplToJson(
        _$RecommendationDataImpl instance) =>
    <String, dynamic>{
      'prediction_summary': instance.predictionSummary,
      'recommended_foods': instance.recommendedFoods,
      'ai_support': instance.aiSupport,
    };

_$PredictionSummaryImpl _$$PredictionSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$PredictionSummaryImpl(
      riskLabel: json['risk_label'] as String,
      probability: (json['probability'] as num).toDouble(),
    );

Map<String, dynamic> _$$PredictionSummaryImplToJson(
        _$PredictionSummaryImpl instance) =>
    <String, dynamic>{
      'risk_label': instance.riskLabel,
      'probability': instance.probability,
    };

_$StuntingHistoryItemImpl _$$StuntingHistoryItemImplFromJson(
        Map<String, dynamic> json) =>
    _$StuntingHistoryItemImpl(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      status: json['status'] as String,
      riskLevel: (json['riskLevel'] as num).toInt(),
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$$StuntingHistoryItemImplToJson(
        _$StuntingHistoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'status': instance.status,
      'riskLevel': instance.riskLevel,
      'score': instance.score,
    };

_$AiMealPlanResponseImpl _$$AiMealPlanResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AiMealPlanResponseImpl(
      analisisGizi: (json['analisis_gizi'] as List<dynamic>)
          .map((e) => AiNutritionAnalysis.fromJson(e as Map<String, dynamic>))
          .toList(),
      rekomendasiMenu: json['rekomendasi_menu'] as Map<String, dynamic>,
      saranAi:
          (json['saran_ai'] as List<dynamic>).map((e) => e as String).toList(),
      catatan: json['catatan'] as String,
    );

Map<String, dynamic> _$$AiMealPlanResponseImplToJson(
        _$AiMealPlanResponseImpl instance) =>
    <String, dynamic>{
      'analisis_gizi': instance.analisisGizi,
      'rekomendasi_menu': instance.rekomendasiMenu,
      'saran_ai': instance.saranAi,
      'catatan': instance.catatan,
    };

_$AiNutritionAnalysisImpl _$$AiNutritionAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$AiNutritionAnalysisImpl(
      nutrisi: json['nutrisi'] as String,
      status: json['status'] as String,
      kebutuhan: json['kebutuhan'] as String,
      asupan: json['asupan'] as String,
      catatan: json['catatan'] as String,
    );

Map<String, dynamic> _$$AiNutritionAnalysisImplToJson(
        _$AiNutritionAnalysisImpl instance) =>
    <String, dynamic>{
      'nutrisi': instance.nutrisi,
      'status': instance.status,
      'kebutuhan': instance.kebutuhan,
      'asupan': instance.asupan,
      'catatan': instance.catatan,
    };

_$AiMenuRecommendationImpl _$$AiMenuRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$AiMenuRecommendationImpl(
      sarapan: AiMeal.fromJson(json['sarapan'] as Map<String, dynamic>),
      makanSiang: AiMeal.fromJson(json['makan_siang'] as Map<String, dynamic>),
      makanMalam: AiMeal.fromJson(json['makan_malam'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AiMenuRecommendationImplToJson(
        _$AiMenuRecommendationImpl instance) =>
    <String, dynamic>{
      'sarapan': instance.sarapan,
      'makan_siang': instance.makanSiang,
      'makan_malam': instance.makanMalam,
    };

_$AiMealImpl _$$AiMealImplFromJson(Map<String, dynamic> json) => _$AiMealImpl(
      menu: (json['menu'] as List<dynamic>).map((e) => e as String).toList(),
      alasan: json['alasan'] as String,
    );

Map<String, dynamic> _$$AiMealImplToJson(_$AiMealImpl instance) =>
    <String, dynamic>{
      'menu': instance.menu,
      'alasan': instance.alasan,
    };
