import '../entities/meal_plan.dart';
import '../repositories/stunting_food_repository.dart';

class GetCurrentMealPlan {
  final StuntingFoodRepository repository;

  const GetCurrentMealPlan(this.repository);

  Future<MealPlan?> call() => repository.getCurrentMealPlan();
}
