import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/tips_remote_datasource.dart';
import '../../data/repositories/tips_repository_impl.dart';
import '../../domain/repositories/tips_repository.dart';
import '../../domain/entities/tip_category.dart';
import '../../domain/entities/pregnancy_tip.dart';

// Datasource Provider
final tipsDatasourceProvider = Provider<TipsRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return TipsRemoteDatasource(dio);
});

// Repository Provider
final tipsRepositoryProvider = Provider<TipsRepository>((ref) {
  final datasource = ref.watch(tipsDatasourceProvider);
  return TipsRepositoryImpl(datasource);
});

// Categories Provider
final categoriesProvider =
    FutureProvider<List<TipCategory>>((ref) async {
  final repository = ref.watch(tipsRepositoryProvider);
  return await repository.getCategories();
});

// Tips Provider dengan parameter
final tipsProvider = FutureProvider.family<List<PregnancyTip>, TipsParams>(
  (ref, params) async {
    final repository = ref.watch(tipsRepositoryProvider);
    return await repository.getTips(
      categoryId: params.categoryId,
      categorySlug: params.categorySlug,
      search: params.search,
    );
  },
);

// Tip Detail Provider
final tipDetailProvider = FutureProvider.family<PregnancyTip, int>(
  (ref, tipId) async {
    final repository = ref.watch(tipsRepositoryProvider);
    return await repository.getTipById(tipId);
  },
);

// Helper class untuk tips params
class TipsParams {
  final int? categoryId;
  final String? categorySlug;
  final String? search;

  TipsParams({
    this.categoryId,
    this.categorySlug,
    this.search,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipsParams &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          categorySlug == other.categorySlug &&
          search == other.search;

  @override
  int get hashCode => categoryId.hashCode ^
      categorySlug.hashCode ^
      search.hashCode;
}

