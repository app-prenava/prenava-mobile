class FoodScanApiResponse {
  final String status;
  final String message;
  final int? foodScanId;
  final String? imageUrl;
  final CoinReward coinReward;
  final ScanSummary summary;
  final List<DetectedFoodItemModel> detectedItems;
  final PlateAnalysisModel plateAnalysis;

  FoodScanApiResponse({
    required this.status,
    required this.message,
    this.foodScanId,
    this.imageUrl,
    required this.coinReward,
    required this.summary,
    required this.detectedItems,
    required this.plateAnalysis,
  });

  factory FoodScanApiResponse.fromJson(Map<String, dynamic> json) {
    return FoodScanApiResponse(
      status: json['status'] ?? 'unknown',
      message: json['message'] ?? '',
      foodScanId: json['food_scan_id'],
      imageUrl: json['image_url'],
      coinReward: CoinReward.fromJson(json['coin_reward'] ?? {}),
      summary: ScanSummary.fromJson(json['summary'] ?? {}),
      detectedItems: (json['detected_items'] as List<dynamic>? ?? [])
          .map((e) => DetectedFoodItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      plateAnalysis: PlateAnalysisModel.fromJson(json['plate_analysis'] ?? {}),
    );
  }
}

class CoinReward {
  final bool awarded;
  final double amount;
  final String? message;

  CoinReward({
    required this.awarded,
    required this.amount,
    this.message,
  });

  factory CoinReward.fromJson(Map<String, dynamic> json) {
    return CoinReward(
      awarded: json['awarded'] ?? false,
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      message: json['message'],
    );
  }
}

class ScanSummary {
  final int totalItemsDetected;
  final List<String> categoriesFound;
  final bool hasIronSource;
  final double inferenceTimeMs;

  ScanSummary({
    required this.totalItemsDetected,
    required this.categoriesFound,
    required this.hasIronSource,
    required this.inferenceTimeMs,
  });

  factory ScanSummary.fromJson(Map<String, dynamic> json) {
    return ScanSummary(
      totalItemsDetected: json['total_items_detected'] ?? 0,
      categoriesFound: (json['categories_found'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      hasIronSource: json['has_iron_source'] ?? false,
      inferenceTimeMs: (json['inference_time_ms'] is num)
          ? (json['inference_time_ms'] as num).toDouble()
          : 0.0,
    );
  }
}

class BoundingBoxModel {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double width;
  final double height;
  final double area;

  BoundingBoxModel({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.width,
    required this.height,
    required this.area,
  });

  factory BoundingBoxModel.fromJson(Map<String, dynamic> json) {
    return BoundingBoxModel(
      x1: (json['x1'] as num?)?.toDouble() ?? 0.0,
      y1: (json['y1'] as num?)?.toDouble() ?? 0.0,
      x2: (json['x2'] as num?)?.toDouble() ?? 0.0,
      y2: (json['y2'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DetectedFoodItemModel {
  final int itemId;
  final String name;
  final String originalLabel;
  final double confidence;
  final String category;
  final String colorHex;
  final BoundingBoxModel box;

  DetectedFoodItemModel({
    required this.itemId,
    required this.name,
    required this.originalLabel,
    required this.confidence,
    required this.category,
    required this.colorHex,
    required this.box,
  });

  factory DetectedFoodItemModel.fromJson(Map<String, dynamic> json) {
    return DetectedFoodItemModel(
      itemId: json['item_id'] ?? 0,
      name: json['name'] ?? 'Makanan',
      originalLabel: json['original_label'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? 'sayuran',
      colorHex: json['color_hex'] ?? '#43A047',
      box: BoundingBoxModel.fromJson(json['box'] ?? {}),
    );
  }
}

class CategoryProportionModel {
  final String category;
  final String label;
  final double detectedAreaPixels;
  final double actualPercentage;
  final double targetPercentage;
  final String status;
  final String colorHex;

  CategoryProportionModel({
    required this.category,
    required this.label,
    required this.detectedAreaPixels,
    required this.actualPercentage,
    required this.targetPercentage,
    required this.status,
    required this.colorHex,
  });

  factory CategoryProportionModel.fromJson(Map<String, dynamic> json) {
    return CategoryProportionModel(
      category: json['category'] ?? '',
      label: json['label'] ?? '',
      detectedAreaPixels: (json['detected_area_pixels'] as num?)?.toDouble() ?? 0.0,
      actualPercentage: (json['actual_percentage'] as num?)?.toDouble() ?? 0.0,
      targetPercentage: (json['target_percentage'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'SEIMBANG',
      colorHex: json['color_hex'] ?? '#43A047',
    );
  }
}

class PlateAnalysisModel {
  final int nutritionScore;
  final String balanceStatus; // 'SEIMBANG', 'CUKUP_SEIMBANG', 'KURANG_SEIMBANG'
  final bool hasIronProtein;
  final bool hasFolateVegetable;
  final bool hasFruit;
  final bool hasCarbohydrate;
  final Map<String, CategoryProportionModel> proportionBreakdown;
  final String clinicalFeedback;
  final List<String> actionableRecommendations;

  PlateAnalysisModel({
    required this.nutritionScore,
    required this.balanceStatus,
    required this.hasIronProtein,
    required this.hasFolateVegetable,
    required this.hasFruit,
    required this.hasCarbohydrate,
    required this.proportionBreakdown,
    required this.clinicalFeedback,
    required this.actionableRecommendations,
  });

  factory PlateAnalysisModel.fromJson(Map<String, dynamic> json) {
    final breakdownRaw = json['proportion_breakdown'] as Map<String, dynamic>? ?? {};
    final breakdown = <String, CategoryProportionModel>{};
    breakdownRaw.forEach((key, val) {
      if (val is Map<String, dynamic>) {
        breakdown[key] = CategoryProportionModel.fromJson(val);
      }
    });

    final recs = (json['actionable_recommendations'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return PlateAnalysisModel(
      nutritionScore: json['nutrition_score'] ?? 0,
      balanceStatus: json['balance_status'] ?? 'KURANG_SEIMBANG',
      hasIronProtein: json['has_iron_protein'] ?? false,
      hasFolateVegetable: json['has_folate_vegetable'] ?? false,
      hasFruit: json['has_fruit'] ?? false,
      hasCarbohydrate: json['has_carbohydrate'] ?? false,
      proportionBreakdown: breakdown,
      clinicalFeedback: json['clinical_feedback'] ?? '',
      actionableRecommendations: recs,
    );
  }
}
