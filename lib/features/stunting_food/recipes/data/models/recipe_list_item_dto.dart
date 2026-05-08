class RecipeListItemDto {
  static int _asInt(dynamic v, {int fallback = -1}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  static num? _asNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v.trim());
    return null;
  }

  final int id; // recipe_id
  final int? foodId;
  final String title;
  final int? loves;
  final String? sourceUrl;
  final String? category;
  final int? totalIngredients;
  final int? totalSteps;

  final String? foodName;
  final String? foodImageUrl;
  final String? foodCategory;
  final num? protein;
  final num? calories;
  final num? fat;
  final num? carbohydrates;
  final num? iron;
  final num? calcium;
  final bool hasFoodInfo;

  const RecipeListItemDto({
    required this.id,
    required this.foodId,
    required this.title,
    required this.loves,
    required this.sourceUrl,
    required this.category,
    required this.totalIngredients,
    required this.totalSteps,
    required this.foodName,
    required this.foodImageUrl,
    required this.foodCategory,
    required this.protein,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    required this.iron,
    required this.calcium,
    required this.hasFoodInfo,
  });

  factory RecipeListItemDto.fromJson(Map<String, dynamic> json) {
    final rawId = json.containsKey('id') ? json['id'] : json['recipe_id'];
    final rawFoodId =
        json.containsKey('food_id') ? json['food_id'] : json['foodId'];
    return RecipeListItemDto(
      id: _asInt(rawId),
      foodId: _asInt(rawFoodId, fallback: -1) <= 0
          ? null
          : _asInt(rawFoodId),
      title: json['title']?.toString() ?? '-',
      loves: _asInt(json['loves'], fallback: -1) <= 0
          ? null
          : _asInt(json['loves']),
      sourceUrl: json['source_url']?.toString(),
      category: json['category']?.toString(),
      totalIngredients: _asInt(json['total_ingredients'], fallback: -1) <= 0
          ? null
          : _asInt(json['total_ingredients']),
      totalSteps: _asInt(json['total_steps'], fallback: -1) <= 0
          ? null
          : _asInt(json['total_steps']),
      foodName: json['food_name']?.toString(),
      foodImageUrl: json['food_image_url']?.toString(),
      foodCategory: json['food_category']?.toString(),
      protein: _asNum(json['protein']),
      calories: _asNum(json['calories']),
      fat: _asNum(json['fat']),
      carbohydrates: _asNum(json['carbohydrates']),
      iron: _asNum(json['iron']),
      calcium: _asNum(json['calcium']),
      hasFoodInfo: json['has_food_info'] == true || json['hasFoodInfo'] == true,
    );
  }
}

