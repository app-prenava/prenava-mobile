import '../../domain/entities/meal_plan_progress.dart';

class MealPlanProgressDto {
  final MealPlanProgress entity;

  const MealPlanProgressDto(this.entity);

  factory MealPlanProgressDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final overall = data['overall'] as Map<String, dynamic>? ?? const {};
    final rawDaily = (data['daily_progress'] as List?) ?? const [];

    return MealPlanProgressDto(
      MealPlanProgress(
        mealPlanId: (data['meal_plan_id'] as num?)?.toInt() ?? 0,
        isActive: data['is_active'] == true,
        startDate: DateTime.parse(data['start_date'].toString()),
        endDate: DateTime.parse(data['end_date'].toString()),
        overall: OverallProgress(
          totalItems: (overall['total_items'] as num?)?.toInt() ?? 0,
          completedItems: (overall['completed_items'] as num?)?.toInt() ?? 0,
        ),
        daily: rawDaily.whereType<Map<String, dynamic>>().map((d) {
          return DailyProgress(
            dayIndex: (d['day_index'] as num?)?.toInt() ?? 0,
            totalItems: (d['total_items'] as num?)?.toInt() ?? 0,
            completedItems: (d['completed_items'] as num?)?.toInt() ?? 0,
            completionPercentage:
                (d['completion_percentage'] as num?)?.toInt() ?? 0,
            isDayCompleted: d['is_day_completed'] == true,
          );
        }).toList(),
      ),
    );
  }
}
