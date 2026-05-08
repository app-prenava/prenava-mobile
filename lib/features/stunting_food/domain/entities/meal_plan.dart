import 'food.dart';

class MealPlanTargets {
  final int calories;
  final int protein;
  final int iron;
  final int calcium;

  const MealPlanTargets({
    required this.calories,
    required this.protein,
    required this.iron,
    required this.calcium,
  });
}

class CompletionSummary {
  final int totalItems;
  final int completedItems;

  const CompletionSummary({
    required this.totalItems,
    required this.completedItems,
  });
}

class MealPlanFoodItem {
  final int itemId;
  final String slot;
  final String focusNutrient;
  final Food food;
  final bool isCompleted;
  final DateTime? completedAt;

  const MealPlanFoodItem({
    required this.itemId,
    required this.slot,
    required this.focusNutrient,
    required this.food,
    required this.isCompleted,
    this.completedAt,
  });

  MealPlanFoodItem copyWith({bool? isCompleted, DateTime? completedAt, Food? food}) {
    return MealPlanFoodItem(
      itemId: itemId,
      slot: slot,
      focusNutrient: focusNutrient,
      food: food ?? this.food,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class MealPlanDay {
  final int dayIndex;
  final List<MealPlanFoodItem> meals;

  const MealPlanDay({required this.dayIndex, required this.meals});
}

class MealPlan {
  final int id;
  final int predictionId;
  final DateTime startDate;
  final DateTime endDate;
  final MealPlanTargets targets;
  final List<String> notes;
  final bool isActive;
  final CompletionSummary completionSummary;
  final List<MealPlanDay> days;

  const MealPlan({
    required this.id,
    required this.predictionId,
    required this.startDate,
    required this.endDate,
    required this.targets,
    required this.notes,
    required this.isActive,
    required this.completionSummary,
    required this.days,
  });

  MealPlan copyWith({List<MealPlanDay>? days}) {
    return MealPlan(
      id: id,
      predictionId: predictionId,
      startDate: startDate,
      endDate: endDate,
      targets: targets,
      notes: notes,
      isActive: isActive,
      completionSummary: completionSummary,
      days: days ?? this.days,
    );
  }
}
