import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/shop_remote_datasource.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/repositories/shop_repository.dart';

final shopRemoteDatasourceProvider = Provider<ShopRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return ShopRemoteDatasource(dio);
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final remote = ref.watch(shopRemoteDatasourceProvider);
  return ShopRepositoryImpl(remote);
});

class ShopState {
  final bool isLoading;
  final String? error;
  final List<ProductModel> all;
  final List<ProductModel> filtered;
  final String query;

  const ShopState({
    this.isLoading = false,
    this.error,
    this.all = const [],
    this.filtered = const [],
    this.query = '',
  });

  ShopState copyWith({
    bool? isLoading,
    String? error,
    List<ProductModel>? all,
    List<ProductModel>? filtered,
    String? query,
    bool clearError = false,
  }) {
    return ShopState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      query: query ?? this.query,
    );
  }
}

class ShopNotifier extends Notifier<ShopState> {
  @override
  ShopState build() => const ShopState();

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(shopRepositoryProvider);
      final products = await repo.fetchProducts();
      state = state.copyWith(
        isLoading: false,
        all: products,
        filtered: products,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void filter(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      state = state.copyWith(filtered: state.all, query: '');
      return;
    }
    final filtered = state.all
        .where((p) => p.produk.toLowerCase().contains(q))
        .toList();
    state = state.copyWith(filtered: filtered, query: query);
  }
}

final shopNotifierProvider = NotifierProvider<ShopNotifier, ShopState>(
  () => ShopNotifier(),
);
