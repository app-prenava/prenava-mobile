import '../../domain/entities/tip_category.dart';

class TipCategoryModel extends TipCategory {
  TipCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.iconName,
    super.iconUrl,
    super.description,
    required super.tipsCount,
  });

  factory TipCategoryModel.fromJson(Map<String, dynamic> json) {
    return TipCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      iconName: json['icon_name'] as String?,
      iconUrl: json['icon_url'] as String?,
      description: json['description'] as String?,
      tipsCount: (json['tips_count'] as int?) ?? 0,
    );
  }
}

