import '../../domain/repositories/tips_repository.dart';
import '../../domain/entities/tip_category.dart';
import '../../domain/entities/pregnancy_tip.dart';
import '../datasources/tips_remote_datasource.dart';

class TipsRepositoryImpl implements TipsRepository {
  final TipsRemoteDatasource _datasource;

  TipsRepositoryImpl(this._datasource);

  @override
  Future<List<TipCategory>> getCategories() async {
    final models = await _datasource.getCategories();
    return models;
  }

  @override
  Future<List<PregnancyTip>> getTips({
    int? categoryId,
    String? categorySlug,
    String? search,
  }) async {
    final models = await _datasource.getTips(
      categoryId: categoryId,
      categorySlug: categorySlug,
      search: search,
    );
    return models;
  }

  @override
  Future<PregnancyTip> getTipById(int id) async {
    final model = await _datasource.getTipById(id);
    return model;
  }
}

