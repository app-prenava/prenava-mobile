import '../../domain/entities/food.dart';

class RecipeDto {
  final String? ingredients;
  final String? steps;
  final String? sourceUrl;
  final String? category;
  final int? loves;
  final int? totalIngredients;
  final int? totalSteps;
  final DateTime? syncedAt;

  const RecipeDto({
    this.ingredients,
    this.steps,
    this.sourceUrl,
    this.category,
    this.loves,
    this.totalIngredients,
    this.totalSteps,
    this.syncedAt,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) => RecipeDto(
    ingredients: json['ingredients']?.toString(),
    steps: json['steps']?.toString(),
    sourceUrl: json['source_url']?.toString(),
    category: json['category']?.toString(),
    loves: (json['loves'] as num?)?.toInt(),
    totalIngredients: (json['total_ingredients'] as num?)?.toInt(),
    totalSteps: (json['total_steps'] as num?)?.toInt(),
    syncedAt: json['synced_at'] == null
        ? null
        : DateTime.tryParse(json['synced_at'].toString()),
  );

  Recipe toEntity() => Recipe(
    ingredients: ingredients,
    steps: steps,
    sourceUrl: sourceUrl,
    category: category,
    loves: loves,
    totalIngredients: totalIngredients,
    totalSteps: totalSteps,
    syncedAt: syncedAt,
  );
}

class FoodDto {
  final int id;
  final String name;
  final String? category;
  final num protein;
  final num calories;
  final num fat;
  final num carbohydrates;
  final num? iron;
  final num? calcium;
  final num? vitaminA;
  final String? imageUrl;
  final String? description;
  final RecipeDto? recipe;

  const FoodDto({
    required this.id,
    required this.name,
    this.category,
    required this.protein,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    this.iron,
    this.calcium,
    this.vitaminA,
    this.imageUrl,
    this.description,
    this.recipe,
  });

  factory FoodDto.fromJson(Map<String, dynamic> json) => FoodDto(
    id: json['id'] as int,
    name: json['name'].toString(),
    category: json['category']?.toString(),
    protein: (json['protein'] as num?) ?? 0,
    calories: (json['calories'] as num?) ?? 0,
    fat: (json['fat'] as num?) ?? 0,
    carbohydrates: (json['carbohydrates'] as num?) ?? 0,
    iron: json['iron'] as num?,
    calcium: json['calcium'] as num?,
    vitaminA: json['vitamin_a'] as num?,
    imageUrl: json['image_url']?.toString(),
    description: json['description']?.toString(),
    recipe: json['recipe'] is Map<String, dynamic>
        ? RecipeDto.fromJson(json['recipe'] as Map<String, dynamic>)
        : null,
  );

  Food toEntity() => Food(
    id: id,
    name: name,
    category: category,
    protein: protein.toDouble(),
    calories: calories.toDouble(),
    fat: fat.toDouble(),
    carbohydrates: carbohydrates.toDouble(),
    iron: iron?.toDouble(),
    calcium: calcium?.toDouble(),
    vitaminA: vitaminA?.toDouble(),
    imageUrl: imageUrl,
    description: description,
    recipe: recipe?.toEntity(),
  );
}
