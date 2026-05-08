import '../../domain/entities/food.dart';
import '../../domain/entities/meal_plan.dart';
import '../../domain/entities/meal_plan_progress.dart';
import '../../domain/entities/preference.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/stunting_food_repository.dart';
import '../datasource/stunting_food_local_cache_datasource.dart';
import '../datasource/stunting_food_remote_datasource.dart';
import '../models/preference_dto.dart';

class StuntingFoodRepositoryImpl implements StuntingFoodRepository {
  final StuntingFoodRemoteDatasource remote;
  final StuntingFoodLocalCacheDatasource cache;

  StuntingFoodRepositoryImpl({required this.remote, required this.cache});

  @override
  Future<List<Food>> getFoods({int perPage = 10, String? search}) async {
    final dtos = await remote.getFoods(perPage: perPage, search: search);
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Food> getFoodDetail(int id) async {
    final dto = await remote.getFoodDetail(id);
    return dto.toEntity();
  }

  @override
  Future<Recipe?> getRecipeByFoodId(int foodId) async {
    final dto = await remote.getRecipeByFoodId(foodId);
    return dto?.toEntity();
  }

  @override
  Future<RecommendationBundle> getRecommendations(int predictionId) async {
    final cached = cache.getRecommendation(predictionId);
    if (cached != null) return cached;

    final dto = await remote.getRecommendations(predictionId);
    final entity = dto.toEntity();
    if (!entity.needsPreferences) {
      cache.saveRecommendation(predictionId, entity);
    }
    return entity;
  }

  @override
  Future<StuntingPreference?> getPreferences() async {
    final dto = await remote.getPreferences();
    return dto?.toEntity();
  }

  @override
  Future<void> savePreferences(StuntingPreference preference) async {
    await remote.savePreferences(PreferenceDto.fromEntity(preference));
    cache.invalidateRecommendationCaches();
  }



  @override
  Future<MealPlan> generateMealPlanDeterministic(int predictionId) async {
    final dto = await remote.generateMealPlanDeterministic(predictionId);
    return dto.entity;
  }

  @override
  Future<MealPlan> createMealPlan({
    required int predictionId,
    int days = 7,
  }) async {
    final dto = await remote.createMealPlan(
      predictionId: predictionId,
      days: days,
    );
    cache.invalidateMealPlanCaches();
    cache.saveCurrentMealPlan(dto.entity);
    return dto.entity;
  }

  @override
  Future<MealPlan?> getCurrentMealPlan() async {
    final cached = cache.getCurrentMealPlan();
    if (cached != null) return cached;

    final dto = await remote.getCurrentMealPlan();
    final entity = dto?.entity;
    if (entity != null) cache.saveCurrentMealPlan(entity);
    return entity;
  }

  @override
  Future<List<MealPlan>> getMealPlanHistory({int perPage = 10}) async {
    final dtos = await remote.getMealPlanHistory(perPage: perPage);
    return dtos.map((e) => e.entity).toList();
  }

  @override
  Future<MealPlan> refreshMealPlanDay({
    required int mealPlanId,
    required int dayIndex,
  }) async {
    final dto = await remote.refreshMealPlanDay(
      mealPlanId: mealPlanId,
      dayIndex: dayIndex,
    );
    cache.invalidateMealPlanCaches();
    cache.saveCurrentMealPlan(dto.entity);
    return dto.entity;
  }

  @override
  Future<MealPlan> updateMealItemCompletion({
    required int itemId,
    required bool isCompleted,
  }) async {
    final dto = await remote.updateMealItemCompletion(
      itemId: itemId,
      isCompleted: isCompleted,
    );
    cache.invalidateMealPlanCaches();
    cache.saveCurrentMealPlan(dto.entity);
    return dto.entity;
  }

  @override
  Future<MealPlanProgress> getMealPlanProgress(int mealPlanId) async {
    final dto = await remote.getMealPlanProgress(mealPlanId);
    return dto.entity;
  }

  @override
  Future<void> deleteMealPlan(int mealPlanId) async {
    await remote.deleteMealPlan(mealPlanId);
    cache.invalidateMealPlanCaches();
  }
}
