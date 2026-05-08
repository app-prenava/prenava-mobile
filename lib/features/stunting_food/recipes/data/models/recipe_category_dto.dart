class RecipeCategoryDto {
  static int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  final String category;
  final int total;
  final int totalWithFoodInfo;

  const RecipeCategoryDto({
    required this.category,
    required this.total,
    required this.totalWithFoodInfo,
  });

  factory RecipeCategoryDto.fromJson(Map<String, dynamic> json) {
    return RecipeCategoryDto(
      category: json['category']?.toString() ?? '',
      total: _asInt(json['total']),
      totalWithFoodInfo: _asInt(json['total_with_food_info']),
    );
  }
}

