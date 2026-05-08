import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../data/datasource/recipes_remote_datasource.dart';
import '../../data/models/recipe_category_dto.dart';
import '../../data/models/recipe_detail_dto.dart';
import '../../data/models/recipe_list_item_dto.dart';
import 'recipes_cache.dart';

final recipesMemoryCacheProvider = Provider<RecipesMemoryCache>((ref) {
  return RecipesMemoryCache();
});

final recipesRemoteDatasourceProvider = Provider<RecipesRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return RecipesRemoteDatasource(dio);
});

final recipeCategoriesProvider =
    FutureProvider<List<RecipeCategoryDto>>((ref) async {
  final cache = ref.read(recipesMemoryCacheProvider);
  final cached = cache.get<List<RecipeCategoryDto>>('recipe_categories');
  if (cached != null) return cached;

  final ds = ref.watch(recipesRemoteDatasourceProvider);
  final result = await ds.fetchRecipeCategories();
  cache.put('recipe_categories', result);
  return result;
});

final categoriesProvider = recipeCategoriesProvider;

String recipesFriendlyError(Object e) {
  if (e is DioException) {
    final code = e.response?.statusCode;
    if (code == 500) {
      return 'Server sedang bermasalah. Coba lagi beberapa saat.';
    }
    if (code == 404) {
      return 'Data tidak ditemukan.';
    }
    if (code == 401) {
      return 'Sesi kamu sudah habis. Silakan login lagi.';
    }
    if (code != null) {
      return 'Terjadi kendala (HTTP $code). Coba lagi.';
    }
    return 'Koneksi bermasalah. Coba lagi.';
  }
  return 'Terjadi kesalahan. Coba lagi.';
}

class RecipeListState {
  final String? category;
  final String? search;
  final bool hasFoodInfoOnly;
  final String sort; // popular | newest
  final int perPage;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final String? warning;
  final List<RecipeListItemDto> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const RecipeListState({
    required this.category,
    required this.search,
    required this.hasFoodInfoOnly,
    required this.sort,
    required this.perPage,
    required this.loading,
    required this.loadingMore,
    required this.error,
    required this.warning,
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  const RecipeListState.initial()
      : category = null,
        search = null,
        hasFoodInfoOnly = true,
        sort = 'popular',
        perPage = 20,
        loading = false,
        loadingMore = false,
        error = null,
        warning = null,
        items = const [],
        currentPage = 0,
        lastPage = 1,
        total = 0;

  RecipeListState copyWith({
    String? category,
    bool clearCategory = false,
    String? search,
    bool clearSearch = false,
    bool? hasFoodInfoOnly,
    String? sort,
    int? perPage,
    bool? loading,
    bool? loadingMore,
    String? error,
    String? warning,
    List<RecipeListItemDto>? items,
    int? currentPage,
    int? lastPage,
    int? total,
  }) {
    return RecipeListState(
      category: clearCategory ? null : (category ?? this.category),
      search: clearSearch ? null : (search ?? this.search),
      hasFoodInfoOnly: hasFoodInfoOnly ?? this.hasFoodInfoOnly,
      sort: sort ?? this.sort,
      perPage: perPage ?? this.perPage,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error,
      warning: warning,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }
}

class RecipeListNotifier extends Notifier<RecipeListState> {
  Timer? _debounce;
  CancelToken? _cancelToken;

  @override
  RecipeListState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _cancelToken?.cancel();
    });
    return const RecipeListState.initial();
  }

  String _cacheKey({
    required String? category,
    required String? search,
    required bool hasFoodInfoOnly,
    required String sort,
    required int page,
    required int perPage,
  }) {
    return 'recipes:${category ?? ''}:${search ?? ''}:${hasFoodInfoOnly ? 1 : 0}:$sort:$page:$perPage';
  }

  Future<void> initDefaultCategory() async {
    if (state.category != null || state.loading) return;
    try {
      final categories = await ref.read(recipeCategoriesProvider.future);
      if (categories.isEmpty) {
        await setCategory(null);
        return;
      }
      final cat = categories.first.category;
      await setCategory(cat);
    } catch (_) {
      // Jika kategori error (mis. 500), tetap load list tanpa filter kategori.
      await setCategory(null);
    }
  }

  Future<void> setCategory(String? category) async {
    if (state.category == category && state.items.isNotEmpty) return;
    state = state.copyWith(
      category: category,
      items: const [],
      currentPage: 0,
      lastPage: 1,
      total: 0,
      loading: true,
      error: null,
      warning: null,
    );
    await _fetchPage(1);
  }

  Future<void> setHasFoodInfoOnly(bool v) async {
    if (state.hasFoodInfoOnly == v && state.items.isNotEmpty) return;
    state = state.copyWith(
      hasFoodInfoOnly: v,
      items: const [],
      currentPage: 0,
      lastPage: 1,
      total: 0,
      loading: true,
      error: null,
      warning: null,
    );
    await _fetchPage(1);
  }

  Future<void> setSort(String sort) async {
    if (state.sort == sort && state.items.isNotEmpty) return;
    state = state.copyWith(
      sort: sort,
      items: const [],
      currentPage: 0,
      lastPage: 1,
      total: 0,
      loading: true,
      error: null,
      warning: null,
    );
    await _fetchPage(1);
  }

  void setSearchDebounced(String? value) {
    final trimmed = value?.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      state = state.copyWith(
        search: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
        items: const [],
        currentPage: 0,
        lastPage: 1,
        total: 0,
        loading: true,
        error: null,
        warning: null,
      );
      await _fetchPage(1);
    });
  }

  Future<void> refresh() async {
    state = state.copyWith(
      items: const [],
      currentPage: 0,
      lastPage: 1,
      total: 0,
      loading: true,
      error: null,
      warning: null,
    );
    await _fetchPage(1);
  }

  Future<void> loadMoreIfNeeded() async {
    if (state.loading || state.loadingMore) return;
    if (state.currentPage >= state.lastPage) return;
    state = state.copyWith(loadingMore: true, error: null);
    await _fetchPage(state.currentPage + 1, append: true);
  }

  Future<void> _fetchPage(int page, {bool append = false}) async {
    try {
      _cancelToken?.cancel();
      _cancelToken = CancelToken();

      final cache = ref.read(recipesMemoryCacheProvider);
      final key = _cacheKey(
        category: state.category,
        search: state.search,
        hasFoodInfoOnly: state.hasFoodInfoOnly,
        sort: state.sort,
        page: page,
        perPage: state.perPage,
      );
      final cached = cache.get<PaginatedRecipeListDto>(key);

      late final PaginatedRecipeListDto result;
      if (cached != null) {
        result = cached;
      } else {
        final ds = ref.read(recipesRemoteDatasourceProvider);
        try {
          result = await ds.fetchRecipes(
            category: state.category,
            search: state.search,
            hasFoodInfo: state.hasFoodInfoOnly ? true : null,
            sort: state.sort,
            page: page,
            perPage: state.perPage,
            cancelToken: _cancelToken,
          );
        } on DioException catch (e) {
          // Workaround untuk bug backend: filter category bisa 500 (ambiguous column).
          // Fallback: ulangi request tanpa category agar list tetap usable.
          final code = e.response?.statusCode;
          final hasCategory =
              state.category != null && state.category!.trim().isNotEmpty;
          if (code == 500 && hasCategory) {
            result = await ds.fetchRecipes(
              category: null,
              search: state.search,
              hasFoodInfo: state.hasFoodInfoOnly ? true : null,
              sort: state.sort,
              page: page,
              perPage: state.perPage,
              cancelToken: _cancelToken,
            );
            state = state.copyWith(
              warning:
                  'Filter kategori sedang bermasalah di server. Menampilkan semua resep.',
            );
          } else {
            rethrow;
          }
        }
        cache.put(key, result);
      }

      final newItems = append ? [...state.items, ...result.data] : result.data;
      final sanitized = newItems.where((e) => e.id > 0).toList();

      // Sort: items with images first
      sanitized.sort((a, b) {
        final hasImgA = a.foodImageUrl != null && a.foodImageUrl!.isNotEmpty;
        final hasImgB = b.foodImageUrl != null && b.foodImageUrl!.isNotEmpty;
        if (hasImgA && !hasImgB) return -1;
        if (!hasImgA && hasImgB) return 1;
        return 0;
      });
      if (kDebugMode) {
        debugPrint(
          '[RECIPES] page=$page fetched=${result.data.length} merged=${newItems.length} sanitized=${sanitized.length}',
        );
      }
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        items: sanitized,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        total: result.total,
        error: null,
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) return;
      state = state.copyWith(
        loading: false,
        loadingMore: false,
        error: recipesFriendlyError(e),
      );
    }
  }

  // cleanup is handled via ref.onDispose in build()
}

final recipeListNotifierProvider =
    NotifierProvider<RecipeListNotifier, RecipeListState>(
  RecipeListNotifier.new,
);

final recipeListControllerProvider = recipeListNotifierProvider;

final recipeDetailProvider =
    FutureProvider.family<RecipeDetailDto?, int>((ref, recipeId) async {
  final cache = ref.read(recipesMemoryCacheProvider);
  final key = 'recipe_detail_by_id:$recipeId';
  final cached = cache.get<RecipeDetailDto?>(key);
  if (cached != null) return cached;

  final ds = ref.read(recipesRemoteDatasourceProvider);
  RecipeDetailDto? detail;
  try {
    detail = await ds.fetchRecipeDetailById(recipeId);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      detail = null;
    } else {
      rethrow;
    }
  }
  cache.put(key, detail);
  return detail;
});

