import '../../domain/entities/meal_plan.dart';
import 'food_dto.dart';

class MealPlanDto {
  final MealPlan entity;

  const MealPlanDto(this.entity);

  factory MealPlanDto.fromJson(Map<String, dynamic> json) {
    final targets = json['targets'] as Map<String, dynamic>? ?? const {};
    final summary =
        json['completion_summary'] as Map<String, dynamic>? ?? const {};
    final daysJson = (json['days'] as List?) ?? const [];

    final days = daysJson.whereType<Map<String, dynamic>>().map((d) {
      final meals = ((d['meals'] as List?) ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((m) {
            final foodMap = m['food'] as Map<String, dynamic>? ?? const {};
            return MealPlanFoodItem(
              itemId: (m['item_id'] as num?)?.toInt() ?? 0,
              slot: m['slot']?.toString() ?? 'snack',
              focusNutrient: m['focus_nutrient']?.toString() ?? '-',
              food: FoodDto.fromJson(foodMap).toEntity(),
              isCompleted: m['is_completed'] == true,
              completedAt: m['completed_at'] == null
                  ? null
                  : DateTime.tryParse(m['completed_at'].toString()),
            );
          })
          .toList();
      return MealPlanDay(
        dayIndex: (d['day_index'] as num?)?.toInt() ?? 0,
        meals: meals,
      );
    }).toList();

    return MealPlanDto(
      MealPlan(
        id: (json['id'] as num?)?.toInt() ?? 0,
        predictionId: (json['prediction_id'] as num?)?.toInt() ?? 0,
        startDate: DateTime.parse(json['start_date'].toString()),
        endDate: DateTime.parse(json['end_date'].toString()),
        targets: MealPlanTargets(
          calories: (targets['calories'] as num?)?.toInt() ?? 0,
          protein: (targets['protein'] as num?)?.toInt() ?? 0,
          iron: (targets['iron'] as num?)?.toInt() ?? 0,
          calcium: (targets['calcium'] as num?)?.toInt() ?? 0,
        ),
        notes: ((json['notes'] as List?) ?? const []).map((e) => '$e').toList(),
        isActive: json['is_active'] == true,
        completionSummary: CompletionSummary(
          totalItems: (summary['total_items'] as num?)?.toInt() ?? 0,
          completedItems: (summary['completed_items'] as num?)?.toInt() ?? 0,
        ),
        days: days,
      ),
    );
  }
}
