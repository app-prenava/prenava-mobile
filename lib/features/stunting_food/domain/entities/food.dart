class Recipe {
  final String? ingredients;
  final String? steps;
  final String? sourceUrl;
  final String? category;
  final int? loves;
  final int? totalIngredients;
  final int? totalSteps;
  final DateTime? syncedAt;

  const Recipe({
    this.ingredients,
    this.steps,
    this.sourceUrl,
    this.category,
    this.loves,
    this.totalIngredients,
    this.totalSteps,
    this.syncedAt,
  });
}

class Food {
  final int id;
  final String name;
  final String? category;
  final double protein;
  final double calories;
  final double fat;
  final double carbohydrates;
  final double? iron;
  final double? calcium;
  final double? vitaminA;
  final String? imageUrl;
  final String? description;
  final Recipe? recipe;

  const Food({
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
}
