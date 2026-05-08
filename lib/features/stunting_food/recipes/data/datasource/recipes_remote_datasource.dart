import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/recipe_category_dto.dart';
import '../models/recipe_detail_dto.dart';
import '../models/recipe_list_item_dto.dart';

Map<String, dynamic> _normalizeRecipeRow(Map raw) {
  final row = Map<String, dynamic>.from(raw);
  final attributesKey = row.keys.firstWhere(
    (k) => k.toString().contains('attributes'),
    orElse: () => '',
  );

  if (attributesKey.toString().isNotEmpty && row[attributesKey] is Map) {
    final attrs = Map<String, dynamic>.from(row[attributesKey] as Map);
    if (row.containsKey('has_food_info')) {
      attrs['has_food_info'] = row['has_food_info'];
    }
    return attrs;
  }

  return row;
}

class PaginatedRecipeListDto {
  final List<RecipeListItemDto> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const PaginatedRecipeListDto({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedRecipeListDto.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final list = (json['data'] as List? ?? const []);
    final parsed = list
        .whereType<Map>()
        .map(_normalizeRecipeRow)
        .map(RecipeListItemDto.fromJson)
        .toList();
    if (kDebugMode) {
      final first = list.isNotEmpty && list.first is Map ? list.first as Map : null;
      final firstNormalized = first == null ? null : _normalizeRecipeRow(first);
      debugPrint(
        '[RECIPES] raw_count=${list.length} parsed_count=${parsed.length} first_keys=${firstNormalized?.keys.toList()}',
      );
      if (parsed.isNotEmpty) {
        debugPrint(
          '[RECIPES] first_parsed id=${parsed.first.id} title=${parsed.first.title}',
        );
      }
    }
    return PaginatedRecipeListDto(
      data: parsed,
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      perPage: (meta['per_page'] as num?)?.toInt() ?? 20,
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class RecipesRemoteDatasource {
  final Dio _dio;
  RecipesRemoteDatasource(this._dio);

  Future<List<RecipeCategoryDto>> fetchRecipeCategories() async {
    final response = await _dio.get('/stunting/recipes/categories');
    final list = (response.data['data'] as List? ?? const []);
    return list
        .whereType<Map>()
        .map((e) => RecipeCategoryDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<PaginatedRecipeListDto> fetchRecipes({
    required String? category,
    required String? search,
    required bool? hasFoodInfo,
    required String sort, // popular | newest
    required int page,
    required int perPage,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get(
      '/stunting/recipes',
      cancelToken: cancelToken,
      queryParameters: {
        'scope': 'receipt',
        if (category != null && category.isNotEmpty) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
        if (hasFoodInfo != null) 'has_food_info': hasFoodInfo ? 1 : 0,
        'sort': sort,
        'page': page,
        'per_page': perPage,
      },
    );
    return PaginatedRecipeListDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<RecipeDetailDto> fetchRecipeDetailById(int recipeId) async {
    final response = await _dio.get('/stunting/recipes/by-id/$recipeId');
    return RecipeDetailDto.fromJson(response.data as Map<String, dynamic>);
  }
}

