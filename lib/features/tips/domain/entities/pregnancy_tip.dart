import 'tip_category.dart';
import 'created_by.dart';

class PregnancyTip {
  final int id;
  final String judul;
  final String konten;
  final TipCategory? category;
  final CreatedBy? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  PregnancyTip({
    required this.id,
    required this.judul,
    required this.konten,
    this.category,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}

