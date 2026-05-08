class OverallProgress {
  final int totalItems;
  final int completedItems;

  const OverallProgress({
    required this.totalItems,
    required this.completedItems,
  });
}

class DailyProgress {
  final int dayIndex;
  final int totalItems;
  final int completedItems;
  final int completionPercentage;
  final bool isDayCompleted;

  const DailyProgress({
    required this.dayIndex,
    required this.totalItems,
    required this.completedItems,
    required this.completionPercentage,
    required this.isDayCompleted,
  });
}

class MealPlanProgress {
  final int mealPlanId;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final OverallProgress overall;
  final List<DailyProgress> daily;

  const MealPlanProgress({
    required this.mealPlanId,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.overall,
    required this.daily,
  });
}
