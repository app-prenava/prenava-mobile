class StuntingQuestion {
  final String key;
  final String label;
  final String type;
  final bool isRequired;
  final List<StuntingOption>? options;
  final double? min;
  final double? max;
  final String? unit;

  const StuntingQuestion({
    required this.key,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.options,
    this.min,
    this.max,
    this.unit,
  });

  factory StuntingQuestion.fromJson(Map<String, dynamic> json) {
    return StuntingQuestion(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: json['type'] as String? ?? '',
      isRequired: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => StuntingOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'type': type,
        'required': isRequired,
        'options': options?.map((e) => e.toJson()).toList(),
        'min': min,
        'max': max,
        'unit': unit,
      };
}

class StuntingOption {
  final dynamic value;
  final String label;

  const StuntingOption({
    required this.value,
    required this.label,
  });

  factory StuntingOption.fromJson(Map<String, dynamic> json) {
    return StuntingOption(
      value: json['value'],
      label: json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
}

class ShapFactor {
  final String feature;
  final String impact;
  final double value;
  final String? message;

  const ShapFactor({
    required this.feature,
    required this.impact,
    required this.value,
    this.message,
  });

  factory ShapFactor.fromJson(Map<String, dynamic> json) {
    return ShapFactor(
      feature: json['feature'] as String? ?? '',
      impact: json['impact'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'feature': feature,
        'impact': impact,
        'value': value,
        'message': message,
      };
}

class ShapExplanation {
  final String method;
  final List<ShapFactor> topFactors;

  const ShapExplanation({
    required this.method,
    required this.topFactors,
  });

  factory ShapExplanation.fromJson(Map<String, dynamic> json) {
    return ShapExplanation(
      method: json['method'] as String? ?? '',
      topFactors: (json['top_factors'] as List<dynamic>?)
              ?.map((e) => ShapFactor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method,
        'top_factors': topFactors.map((e) => e.toJson()).toList(),
      };
}

class PredictionResult {
  final int predictionId;
  final String riskLabel;
  final double score;
  final int riskLevel;
  final String recommendation;
  final ShapExplanation? explanation;
  final Map<String, dynamic>? inputData;
  final AiMealPlanResponse? aiMealPlan;
  final bool localOnly;
  final bool productionReady;
  final String? modelStatus;
  final List<String> warnings;
  final double? threshold;
  final String? ageBand;

  const PredictionResult({
    required this.predictionId,
    required this.riskLabel,
    required this.score,
    required this.riskLevel,
    required this.recommendation,
    this.explanation,
    this.inputData,
    this.aiMealPlan,
    this.localOnly = false,
    this.productionReady = false,
    this.modelStatus,
    this.warnings = const [],
    this.threshold,
    this.ageBand,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      predictionId:
          (json['predictionId'] ?? json['prediction_id'] as num?)?.toInt() ?? 0,
      riskLabel: json['riskLabel'] ?? json['risk_label'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      riskLevel:
          (json['riskLevel'] ?? json['risk_level'] as num?)?.toInt() ?? 0,
      recommendation: json['recommendation'] as String? ?? '',
      explanation: json['explanation'] != null
          ? ShapExplanation.fromJson(
              json['explanation'] as Map<String, dynamic>)
          : null,
      inputData:
          (json['inputData'] ?? json['input_data']) as Map<String, dynamic>?,
      aiMealPlan: json['aiMealPlan'] != null
          ? AiMealPlanResponse.fromJson(
              json['aiMealPlan'] as Map<String, dynamic>)
          : (json['ai_meal_plan'] != null
              ? AiMealPlanResponse.fromJson(
                  json['ai_meal_plan'] as Map<String, dynamic>)
              : null),
      localOnly: json['local_only'] as bool? ?? false,
      productionReady: json['production_ready'] as bool? ?? false,
      modelStatus: json['model_status'] as String?,
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      threshold: (json['threshold'] as num?)?.toDouble(),
      ageBand: json['age_band'] as String?,
    );
  }

  factory PredictionResult.fromLocalV2(
    Map<String, dynamic> json, {
    required Map<String, dynamic> inputData,
  }) {
    final prediction = (json['prediction'] as num?)?.toInt() ?? 0;
    final warnings = (json['warnings'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ??
        const <String>[];
    return PredictionResult(
      predictionId: 0,
      riskLabel: prediction == 1 ? 'Risiko Tinggi' : 'Risiko Rendah',
      score: (json['probability'] as num?)?.toDouble() ?? 0,
      riskLevel: prediction,
      recommendation: prediction == 1
          ? 'Hasil skrining lokal menunjukkan risiko tinggi. Lakukan penilaian antropometri dan konsultasi dengan tenaga kesehatan.'
          : 'Hasil skrining lokal menunjukkan risiko lebih rendah. Tetap pantau pertumbuhan anak secara berkala.',
      inputData: inputData,
      localOnly: json['local_only'] as bool? ?? true,
      productionReady: json['production_ready'] as bool? ?? false,
      modelStatus: json['model_status'] as String?,
      warnings: warnings,
      threshold: (json['threshold'] as num?)?.toDouble(),
      ageBand: json['age_band'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'predictionId': predictionId,
        'riskLabel': riskLabel,
        'score': score,
        'riskLevel': riskLevel,
        'recommendation': recommendation,
        'explanation': explanation?.toJson(),
        'inputData': inputData,
        'aiMealPlan': aiMealPlan?.toJson(),
        'local_only': localOnly,
        'production_ready': productionReady,
        'model_status': modelStatus,
        'warnings': warnings,
        'threshold': threshold,
        'age_band': ageBand,
      };
}

class FoodModel {
  final String id;
  final String name;
  final String? imageUrl;
  final double protein;
  final double calories;
  final double? fat;
  final double? carbohydrates;
  final String? reason;

  const FoodModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.protein,
    required this.calories,
    this.fat,
    this.carbohydrates,
    this.reason,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: (json['imageUrl'] ?? json['image_url']) as String?,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'protein': protein,
        'calories': calories,
        'fat': fat,
        'carbohydrates': carbohydrates,
        'reason': reason,
      };
}

class AiSupportModel {
  final String? cookingGuide;
  final String? nutritionTips;
  final String? mealPlan;

  const AiSupportModel({
    this.cookingGuide,
    this.nutritionTips,
    this.mealPlan,
  });

  factory AiSupportModel.fromJson(Map<String, dynamic> json) {
    return AiSupportModel(
      cookingGuide: json['cooking_guide'] as String?,
      nutritionTips: json['nutrition_tips'] as String?,
      mealPlan: json['meal_plan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'cooking_guide': cookingGuide,
        'nutrition_tips': nutritionTips,
        'meal_plan': mealPlan,
      };
}

class RecommendationResponse {
  final bool success;
  final bool cached;
  final RecommendationData data;

  const RecommendationResponse({
    required this.success,
    required this.cached,
    required this.data,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      success: json['success'] as bool? ?? false,
      cached: json['cached'] as bool? ?? false,
      data: RecommendationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'cached': cached,
        'data': data.toJson(),
      };
}

class RecommendationData {
  final PredictionSummary predictionSummary;
  final List<FoodModel> recommendedFoods;
  final AiSupportModel? aiSupport;

  const RecommendationData({
    required this.predictionSummary,
    required this.recommendedFoods,
    this.aiSupport,
  });

  factory RecommendationData.fromJson(Map<String, dynamic> json) {
    return RecommendationData(
      predictionSummary: PredictionSummary.fromJson(
        (json['prediction_summary'] ?? json['predictionSummary'])
            as Map<String, dynamic>,
      ),
      recommendedFoods: ((json['recommended_foods'] ?? json['recommendedFoods'])
                  as List<dynamic>?)
              ?.map((e) => FoodModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      aiSupport: json['ai_support'] != null
          ? AiSupportModel.fromJson(json['ai_support'] as Map<String, dynamic>)
          : (json['aiSupport'] != null
              ? AiSupportModel.fromJson(
                  json['aiSupport'] as Map<String, dynamic>)
              : null),
    );
  }

  Map<String, dynamic> toJson() => {
        'prediction_summary': predictionSummary.toJson(),
        'recommended_foods': recommendedFoods.map((e) => e.toJson()).toList(),
        'ai_support': aiSupport?.toJson(),
      };
}

class PredictionSummary {
  final String riskLabel;
  final double probability;

  const PredictionSummary({
    required this.riskLabel,
    required this.probability,
  });

  factory PredictionSummary.fromJson(Map<String, dynamic> json) {
    return PredictionSummary(
      riskLabel: (json['risk_label'] ?? json['riskLabel']) as String? ?? '',
      probability: (json['probability'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'risk_label': riskLabel,
        'probability': probability,
      };
}

class StuntingHistoryItem {
  final int id;
  final String date;
  final String status;
  final int riskLevel;
  final double score;

  const StuntingHistoryItem({
    required this.id,
    required this.date,
    required this.status,
    required this.riskLevel,
    required this.score,
  });

  factory StuntingHistoryItem.fromJson(Map<String, dynamic> json) {
    return StuntingHistoryItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? '',
      riskLevel:
          (json['riskLevel'] ?? json['risk_level'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'status': status,
        'riskLevel': riskLevel,
        'score': score,
      };
}

class AiMealPlanResponse {
  final List<AiNutritionAnalysis> analisisGizi;
  final Map<String, dynamic> rekomendasiMenu;
  final List<String> saranAi;
  final String catatan;

  const AiMealPlanResponse({
    required this.analisisGizi,
    required this.rekomendasiMenu,
    required this.saranAi,
    required this.catatan,
  });

  factory AiMealPlanResponse.fromJson(Map<String, dynamic> json) {
    return AiMealPlanResponse(
      analisisGizi:
          ((json['analisis_gizi'] ?? json['analisisGizi']) as List<dynamic>?)
                  ?.map((e) =>
                      AiNutritionAnalysis.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      rekomendasiMenu: ((json['rekomendasi_menu'] ?? json['rekomendasiMenu'])
              as Map<String, dynamic>?) ??
          {},
      saranAi: ((json['saran_ai'] ?? json['saranAi']) as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      catatan: json['catatan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'analisis_gizi': analisisGizi.map((e) => e.toJson()).toList(),
        'rekomendasi_menu': rekomendasiMenu,
        'saran_ai': saranAi,
        'catatan': catatan,
      };
}

class AiNutritionAnalysis {
  final String nutrisi;
  final String status;
  final String kebutuhan;
  final String asupan;
  final String catatan;

  const AiNutritionAnalysis({
    required this.nutrisi,
    required this.status,
    required this.kebutuhan,
    required this.asupan,
    required this.catatan,
  });

  factory AiNutritionAnalysis.fromJson(Map<String, dynamic> json) {
    return AiNutritionAnalysis(
      nutrisi: json['nutrisi'] as String? ?? '',
      status: json['status'] as String? ?? '',
      kebutuhan: json['kebutuhan'] as String? ?? '',
      asupan: json['asupan'] as String? ?? '',
      catatan: json['catatan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nutrisi': nutrisi,
        'status': status,
        'kebutuhan': kebutuhan,
        'asupan': asupan,
        'catatan': catatan,
      };
}

class AiMenuRecommendation {
  final AiMeal sarapan;
  final AiMeal makanSiang;
  final AiMeal makanMalam;

  const AiMenuRecommendation({
    required this.sarapan,
    required this.makanSiang,
    required this.makanMalam,
  });

  factory AiMenuRecommendation.fromJson(Map<String, dynamic> json) {
    return AiMenuRecommendation(
      sarapan: AiMeal.fromJson(json['sarapan'] as Map<String, dynamic>? ?? {}),
      makanSiang: AiMeal.fromJson((json['makan_siang'] ?? json['makanSiang'])
              as Map<String, dynamic>? ??
          {}),
      makanMalam: AiMeal.fromJson((json['makan_malam'] ?? json['makanMalam'])
              as Map<String, dynamic>? ??
          {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'sarapan': sarapan.toJson(),
        'makan_siang': makanSiang.toJson(),
        'makan_malam': makanMalam.toJson(),
      };
}

class AiMeal {
  final List<String> menu;
  final String alasan;

  const AiMeal({
    required this.menu,
    required this.alasan,
  });

  factory AiMeal.fromJson(Map<String, dynamic> json) {
    return AiMeal(
      menu:
          (json['menu'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
      alasan: json['alasan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'menu': menu,
        'alasan': alasan,
      };
}
