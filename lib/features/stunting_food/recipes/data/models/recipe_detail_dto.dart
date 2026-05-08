class RecipeFoodDto {
  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  static num _asNum(dynamic v, {num fallback = 0}) {
    if (v == null) return fallback;
    if (v is num) return v;
    if (v is String) return num.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  static num? _asNumOrNull(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v.trim());
    return null;
  }

  final int id;
  final String name;
  final String? category;
  final String? imageUrl;
  final num protein;
  final num calories;
  final num fat;
  final num carbohydrates;
  final num? iron;
  final num? calcium;
  final num? vitaminA;
  final String? description;

  const RecipeFoodDto({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.protein,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    required this.iron,
    required this.calcium,
    required this.vitaminA,
    required this.description,
  });

  factory RecipeFoodDto.fromJson(Map<String, dynamic> json) {
    return RecipeFoodDto(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '-',
      category: json['category']?.toString(),
      imageUrl: json['image_url']?.toString(),
      protein: _asNum(json['protein']),
      calories: _asNum(json['calories']),
      fat: _asNum(json['fat']),
      carbohydrates: _asNum(json['carbohydrates']),
      iron: _asNumOrNull(json['iron']),
      calcium: _asNumOrNull(json['calcium']),
      vitaminA: _asNumOrNull(json['vitamin_a']),
      description: json['description']?.toString(),
    );
  }
}

class RecipeByIdDto {
  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  final int id;
  final int? foodId;
  final String title;
  final String? ingredients;
  final String? steps;
  final int? loves;
  final String? sourceUrl;
  final String? category;
  final int? totalIngredients;
  final int? totalSteps;

  const RecipeByIdDto({
    required this.id,
    required this.foodId,
    required this.title,
    required this.ingredients,
    required this.steps,
    required this.loves,
    required this.sourceUrl,
    required this.category,
    required this.totalIngredients,
    required this.totalSteps,
  });

  factory RecipeByIdDto.fromJson(Map<String, dynamic> json) {
    final foodId = _asInt(json['food_id'], fallback: -1);
    return RecipeByIdDto(
      id: _asInt(json['id']),
      foodId: foodId <= 0 ? null : foodId,
      title: json['title']?.toString() ?? '-',
      ingredients: json['ingredients']?.toString(),
      steps: json['steps']?.toString(),
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
    );
  }
}

class RecipeDetailDto {
  final RecipeByIdDto recipe;
  final RecipeFoodDto? food;
  final bool hasFoodInfo;

  const RecipeDetailDto({
    required this.recipe,
    required this.food,
    required this.hasFoodInfo,
  });

  factory RecipeDetailDto.fromJson(Map<String, dynamic> json) {
    return RecipeDetailDto(
      recipe: RecipeByIdDto.fromJson(
        (json['data']?['recipe'] as Map<String, dynamic>? ?? const {}),
      ),
      food: (json['data']?['food'] is Map<String, dynamic>)
          ? RecipeFoodDto.fromJson(json['data']?['food'] as Map<String, dynamic>)
          : null,
      hasFoodInfo: json['data']?['has_food_info'] == true,
    );
  }
}

