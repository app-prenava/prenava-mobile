import '../entities/food.dart';
import '../entities/meal_plan.dart';
import '../entities/meal_plan_progress.dart';
import '../entities/preference.dart';
import '../entities/recommendation.dart';

abstract class StuntingFoodRepository {
  Future<List<Food>> getFoods({int perPage = 10, String? search});
  Future<Food> getFoodDetail(int id);
  Future<Recipe?> getRecipeByFoodId(int foodId);

  Future<RecommendationBundle> getRecommendations(int predictionId);
  Future<StuntingPreference?> getPreferences();
  Future<void> savePreferences(StuntingPreference preference);


  Future<MealPlan> generateMealPlanDeterministic(int predictionId);
  Future<MealPlan> createMealPlan({required int predictionId, int days = 7});
  Future<MealPlan?> getCurrentMealPlan();
  Future<List<MealPlan>> getMealPlanHistory({int perPage = 10});
  Future<MealPlan> refreshMealPlanDay({
    required int mealPlanId,
    required int dayIndex,
  });
  Future<MealPlan> updateMealItemCompletion({
    required int itemId,
    required bool isCompleted,
  });
  Future<MealPlanProgress> getMealPlanProgress(int mealPlanId);
  Future<void> deleteMealPlan(int mealPlanId);
}
