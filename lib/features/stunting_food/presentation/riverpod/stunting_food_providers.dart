import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasource/stunting_food_local_cache_datasource.dart';
import '../../data/datasource/stunting_food_remote_datasource.dart';
import '../../data/repository_impl/stunting_food_repository_impl.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/meal_plan.dart';
import '../../domain/entities/meal_plan_progress.dart';
import '../../domain/entities/preference.dart';

import '../../domain/entities/recommendation.dart';
import '../../domain/repositories/stunting_food_repository.dart';

final stuntingFoodRemoteDatasourceProvider =
    Provider<StuntingFoodRemoteDatasource>((ref) {
      final dio = ref.watch(appDioProvider);
      return StuntingFoodRemoteDatasource(dio);
    });

final stuntingFoodLocalCacheProvider =
    Provider<StuntingFoodLocalCacheDatasource>((ref) {
      return StuntingFoodLocalCacheDatasource();
    });

final stuntingFoodRepositoryProvider = Provider<StuntingFoodRepository>((ref) {
  return StuntingFoodRepositoryImpl(
    remote: ref.watch(stuntingFoodRemoteDatasourceProvider),
    cache: ref.watch(stuntingFoodLocalCacheProvider),
  );
});

class MealPlanCurrentState {
  final bool loading;
  final MealPlan? plan;
  final int selectedDayIndex;
  final String? error;

  const MealPlanCurrentState({
    this.loading = false,
    this.plan,
    this.selectedDayIndex = 0,
    this.error,
  });

  MealPlanCurrentState copyWith({
    bool? loading,
    MealPlan? plan,
    int? selectedDayIndex,
    String? error,
  }) {
    return MealPlanCurrentState(
      loading: loading ?? this.loading,
      plan: plan ?? this.plan,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      error: error,
    );
  }
}

class MealPlanCurrentNotifier extends Notifier<MealPlanCurrentState> {
  @override
  MealPlanCurrentState build() => const MealPlanCurrentState(loading: true);

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final repo = ref.read(stuntingFoodRepositoryProvider);
      final plan = await repo.getCurrentMealPlan();
      state = state.copyWith(loading: false, plan: plan, selectedDayIndex: 0);
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  void selectDay(int index) {
    state = state.copyWith(selectedDayIndex: index);
  }

  Future<void> createFromPrediction(int predictionId, {int days = 7}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final repo = ref.read(stuntingFoodRepositoryProvider);
      final plan = await repo.createMealPlan(
        predictionId: predictionId,
        days: days,
      );
      state = state.copyWith(loading: false, plan: plan, selectedDayIndex: 0);
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  Future<void> toggleCompletionOptimistic({
    required int itemId,
    required bool value,
  }) async {
    final existing = state.plan;
    if (existing == null) return;

    final optimisticDays = existing.days.map((day) {
      return MealPlanDay(
        dayIndex: day.dayIndex,
        meals: day.meals.map((m) {
          if (m.itemId == itemId) {
            return m.copyWith(
              isCompleted: value,
              completedAt: value ? DateTime.now() : null,
            );
          }
          return m;
        }).toList(),
      );
    }).toList();

    state = state.copyWith(
      plan: existing.copyWith(days: optimisticDays),
      error: null,
    );

    try {
      final repo = ref.read(stuntingFoodRepositoryProvider);
      final updated = await repo.updateMealItemCompletion(
        itemId: itemId,
        isCompleted: value,
      );
      state = state.copyWith(plan: updated);
    } catch (e) {
      // rollback
      state = state.copyWith(plan: existing, error: '$e');
    }
  }

  Future<void> replaceItemOptimistic({
    required int itemId,
    required Food newFood,
  }) async {
    final existing = state.plan;
    if (existing == null) return;

    final optimisticDays = existing.days.map((day) {
      return MealPlanDay(
        dayIndex: day.dayIndex,
        meals: day.meals.map((m) {
          if (m.itemId == itemId) {
            return m.copyWith(
              food: newFood,
            );
          }
          return m;
        }).toList(),
      );
    }).toList();

    state = state.copyWith(
      plan: existing.copyWith(days: optimisticDays),
    );
  }

  Future<void> refreshDay() async {
    final plan = state.plan;
    if (plan == null) return;
    try {
      final repo = ref.read(stuntingFoodRepositoryProvider);
      final updated = await repo.refreshMealPlanDay(
        mealPlanId: plan.id,
        dayIndex: state.selectedDayIndex,
      );
      state = state.copyWith(plan: updated, error: null);
    } catch (e) {
      state = state.copyWith(error: '$e');
    }
  }
}

final mealPlanCurrentNotifierProvider =
    NotifierProvider<MealPlanCurrentNotifier, MealPlanCurrentState>(
      MealPlanCurrentNotifier.new,
    );

class PreferenceState {
  final bool loading;
  final bool saving;
  final StuntingPreference preference;
  final String? error;

  const PreferenceState({
    this.loading = false,
    this.saving = false,
    this.preference = const StuntingPreference(),
    this.error,
  });

  PreferenceState copyWith({
    bool? loading,
    bool? saving,
    StuntingPreference? preference,
    String? error,
  }) {
    return PreferenceState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      preference: preference ?? this.preference,
      error: error,
    );
  }
}

class PreferenceNotifier extends Notifier<PreferenceState> {
  @override
  PreferenceState build() => const PreferenceState(loading: true);

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final repo = ref.read(stuntingFoodRepositoryProvider);
      final pref = await repo.getPreferences();
      state = state.copyWith(
        loading: false,
        preference: pref ?? const StuntingPreference(),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: '$e');
    }
  }

  void update(StuntingPreference pref) {
    state = state.copyWith(preference: pref, error: null);
  }

  Future<bool> save() async {
    state = state.copyWith(saving: true, error: null);
    try {
      final repo = ref.read(stuntingFoodRepositoryProvider);
      await repo.savePreferences(state.preference);
      state = state.copyWith(saving: false);
      return true;
    } catch (e) {
      state = state.copyWith(saving: false, error: '$e');
      return false;
    }
  }
}

final preferenceProvider = NotifierProvider<PreferenceNotifier, PreferenceState>(
  PreferenceNotifier.new,
);

final stuntingRecommendationProvider =
    FutureProvider.family<RecommendationBundle, int>((ref, predictionId) async {
      final repo = ref.watch(stuntingFoodRepositoryProvider);
      return repo.getRecommendations(predictionId);
    });



final mealPlanHistoryProvider = FutureProvider<List<MealPlan>>((ref) async {
  final repo = ref.watch(stuntingFoodRepositoryProvider);
  return repo.getMealPlanHistory(perPage: 20);
});

final mealPlanProgressProvider = FutureProvider.family<MealPlanProgress, int>((
  ref,
  mealPlanId,
) async {
  final repo = ref.watch(stuntingFoodRepositoryProvider);
  return repo.getMealPlanProgress(mealPlanId);
});

final recipeByFoodProvider = FutureProvider.family<Recipe?, int>((
  ref,
  foodId,
) async {
  final repo = ref.watch(stuntingFoodRepositoryProvider);
  return repo.getRecipeByFoodId(foodId);
});

final foodsProvider = FutureProvider.family<List<Food>, String?>((
  ref,
  search,
) async {
  final repo = ref.watch(stuntingFoodRepositoryProvider);
  return repo.getFoods(perPage: 20, search: search);
});

final foodDetailProvider = FutureProvider.family<Food, int>((ref, id) async {
  final repo = ref.watch(stuntingFoodRepositoryProvider);
  return repo.getFoodDetail(id);
});
