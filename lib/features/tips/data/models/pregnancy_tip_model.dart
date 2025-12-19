import '../../domain/entities/pregnancy_tip.dart';
import 'tip_category_model.dart';
import 'created_by_model.dart';

class PregnancyTipModel extends PregnancyTip {
  PregnancyTipModel({
    required super.id,
    required super.judul,
    required super.konten,
    super.category,
    super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PregnancyTipModel.fromJson(Map<String, dynamic> json) {
    return PregnancyTipModel(
      id: json['id'] as int,
      judul: json['judul'] as String,
      konten: json['konten'] as String,
      category: json['category'] != null
          ? TipCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      createdBy: json['created_by'] != null
          ? CreatedByModel.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

