import 'package:dio/dio.dart';

import '../models/food_dto.dart';
import '../models/meal_plan_dto.dart';
import '../models/preference_dto.dart';
import '../models/progress_dto.dart';
import '../models/recommendation_dto.dart';

class StuntingFoodRemoteDatasource {
  final Dio _dio;

  StuntingFoodRemoteDatasource(this._dio);

  Future<List<FoodDto>> getFoods({int perPage = 10, String? search}) async {
    final response = await _dio.get(
      '/stunting/foods',
      queryParameters: {
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final list = (response.data['data'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(FoodDto.fromJson)
        .toList();
  }

  Future<FoodDto> getFoodDetail(int id) async {
    final response = await _dio.get('/stunting/foods/$id');
    return FoodDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<RecipeDto?> getRecipeByFoodId(int foodId) async {
    try {
      final response = await _dio.get('/stunting/recipes/$foodId');
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return RecipeDto.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<RecommendationDto> getRecommendations(int predictionId) async {
    final response = await _dio.get('/stunting/recommendations/$predictionId');
    return RecommendationDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PreferenceDto?> getPreferences() async {
    try {
      final response = await _dio.get('/stunting/preferences');
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return PreferenceDto.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> savePreferences(PreferenceDto dto) async {
    await _dio.post('/stunting/preferences', data: dto.toJson());
  }



  Future<MealPlanDto> generateMealPlanDeterministic(int predictionId) async {
    final response = await _dio.post(
      '/stunting/meal-plans/generate',
      data: {'prediction_id': predictionId},
    );
    return MealPlanDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<MealPlanDto> createMealPlan({
    required int predictionId,
    int days = 7,
  }) async {
    final response = await _dio.post(
      '/stunting/meal-plans',
      data: {'prediction_id': predictionId, 'days': days},
    );
    return MealPlanDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<MealPlanDto?> getCurrentMealPlan() async {
    try {
      final response = await _dio.get('/stunting/meal-plans/current');
      return MealPlanDto.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<List<MealPlanDto>> getMealPlanHistory({int perPage = 10}) async {
    final response = await _dio.get(
      '/stunting/meal-plans/history',
      queryParameters: {'per_page': perPage},
    );
    final list = (response.data['data'] as List? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(MealPlanDto.fromJson)
        .toList();
  }

  Future<MealPlanDto> refreshMealPlanDay({
    required int mealPlanId,
    required int dayIndex,
  }) async {
    final response = await _dio.post(
      '/stunting/meal-plans/$mealPlanId/refresh-day',
      data: {'day_index': dayIndex},
    );
    return MealPlanDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<MealPlanDto> updateMealItemCompletion({
    required int itemId,
    required bool isCompleted,
  }) async {
    final response = await _dio.post(
      '/stunting/meal-plans/items/$itemId/completion',
      data: {'is_completed': isCompleted},
    );
    return MealPlanDto.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<MealPlanProgressDto> getMealPlanProgress(int mealPlanId) async {
    final response = await _dio.get(
      '/stunting/meal-plans/$mealPlanId/progress',
    );
    return MealPlanProgressDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteMealPlan(int mealPlanId) async {
    await _dio.delete('/stunting/meal-plans/$mealPlanId');
  }
}
