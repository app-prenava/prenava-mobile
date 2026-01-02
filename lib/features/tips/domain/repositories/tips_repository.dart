import '../entities/tip_category.dart';
import '../entities/pregnancy_tip.dart';

abstract class TipsRepository {
  Future<List<TipCategory>> getCategories();
  Future<List<PregnancyTip>> getTips({
    int? categoryId,
    String? categorySlug,
    String? search,
  });
  Future<PregnancyTip> getTipById(int id);
}

