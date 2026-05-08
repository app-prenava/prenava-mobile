import '../../domain/entities/meal_plan.dart';
import '../../domain/entities/recommendation.dart';

class _CacheEntry<T> {
  final T value;
  final DateTime expiresAt;

  const _CacheEntry({required this.value, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class StuntingFoodLocalCacheDatasource {
  final Duration ttl;
  final Map<String, _CacheEntry<dynamic>> _cache = {};

  StuntingFoodLocalCacheDatasource({this.ttl = const Duration(minutes: 10)});

  RecommendationBundle? getRecommendation(int predictionId) {
    final entry = _cache['rec_$predictionId'];
    if (entry == null || entry.isExpired) return null;
    return entry.value as RecommendationBundle;
  }

  void saveRecommendation(int predictionId, RecommendationBundle data) {
    _cache['rec_$predictionId'] = _CacheEntry(
      value: data,
      expiresAt: DateTime.now().add(ttl),
    );
  }

  MealPlan? getCurrentMealPlan() {
    final entry = _cache['current_plan'];
    if (entry == null || entry.isExpired) return null;
    return entry.value as MealPlan;
  }

  void saveCurrentMealPlan(MealPlan data) {
    _cache['current_plan'] = _CacheEntry(
      value: data,
      expiresAt: DateTime.now().add(ttl),
    );
  }

  void invalidateMealPlanCaches() {
    _cache.remove('current_plan');
  }

  void invalidateRecommendationCaches() {
    final keys = _cache.keys.where((k) => k.startsWith('rec_')).toList();
    for (final key in keys) {
      _cache.remove(key);
    }
  }
}
