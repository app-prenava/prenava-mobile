import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/shop_remote_datasource.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/shop_repository.dart';

// Datasource provider
final shopRemoteDatasourceProvider = Provider<ShopRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return ShopRemoteDatasource(dio);
});

// Repository provider
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  final remoteDatasource = ref.watch(shopRemoteDatasourceProvider);
  return ShopRepositoryImpl(remoteDatasource: remoteDatasource);
});

// Shop state
class ShopState {
  final bool isLoading;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;
  final int currentPage;
  final int lastPage;
  final int total;
  final String? error;
  final String? successMessage;

  const ShopState({
    this.isLoading = false,
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.error,
    this.successMessage,
  });

  const ShopState.initial()
      : isLoading = false,
        products = const [],
        filteredProducts = const [],
        searchQuery = '',
        currentPage = 1,
        lastPage = 1,
        total = 0,
        error = null,
        successMessage = null;

  ShopState copyWith({
    bool? isLoading,
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    int? currentPage,
    int? lastPage,
    int? total,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ShopState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  bool get hasMore => currentPage < lastPage;
  
  List<Product> get displayProducts => filteredProducts.isEmpty && searchQuery.isEmpty 
      ? products 
      : filteredProducts;
}

// Shop controller
class ShopNotifier extends Notifier<ShopState> {
  @override
  ShopState build() {
    // Listen to auth state to reload on login/logout
    ref.listen(
      authNotifierProvider.select((state) => state.isAuthenticated),
      (previous, next) {
        if (next && previous != next) {
          loadProducts();
        } else if (!next && previous != next) {
          clearProducts();
        }
      },
    );

    // Load products if authenticated
    Future.microtask(() {
      final isAuthenticated = ref.read(authNotifierProvider).isAuthenticated;
      if (isAuthenticated) {
        loadProducts();
      }
    });

    return const ShopState.initial();
  }

  Future<void> loadProducts({int page = 1, bool loadMore = false}) async {
    if (loadMore && !state.hasMore) return;

    state = state.copyWith(
      isLoading: true,
      clearError: true,
      currentPage: loadMore ? state.currentPage : page,
    );

    try {
      final repository = ref.read(shopRepositoryProvider);
      final result = await repository.getAllProducts(
        page: loadMore ? state.currentPage + 1 : page,
        limit: 30,
      );

      final newProducts = result['products'] as List<Product>;
      
      state = ShopState(
        isLoading: false,
        products: loadMore ? [...state.products, ...newProducts] : newProducts,
        currentPage: result['current_page'] as int,
        lastPage: result['last_page'] as int,
        total: result['total'] as int,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts(page: 1);
  }

  Future<bool> createProduct({
    required Map<String, dynamic> data,
    required String photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(shopRepositoryProvider);
      await repository.createProduct(data: data, photoPath: photoPath);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Produk berhasil ditambahkan',
      );

      // Reload products
      await refreshProducts();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateProduct({
    required int productId,
    required Map<String, dynamic> data,
    String? photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(shopRepositoryProvider);
      await repository.updateProduct(
        productId: productId,
        data: data,
        photoPath: photoPath,
      );

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Produk berhasil diupdate',
      );

      // Reload products
      await refreshProducts();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(shopRepositoryProvider);
      await repository.deleteProduct(productId);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Produk berhasil dihapus',
      );

      // Reload products
      await refreshProducts();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        filteredProducts: [],
      );
      return;
    }

    final filtered = state.products.where((product) {
      final productName = product.productName?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return productName.contains(searchLower);
    }).toList();

    state = state.copyWith(
      searchQuery: query,
      filteredProducts: filtered,
    );
  }

  void clearProducts() {
    state = const ShopState.initial();
  }
}

final shopNotifierProvider = NotifierProvider<ShopNotifier, ShopState>(() {
  return ShopNotifier();
});
