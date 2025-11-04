import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/banner_remote_datasource.dart';
import '../../data/repositories/banner_repository_impl.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/banner_repository.dart';

// Datasource provider
final bannerRemoteDatasourceProvider = Provider<BannerRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return BannerRemoteDatasource(dio);
});

// Repository provider
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final remoteDatasource = ref.watch(bannerRemoteDatasourceProvider);
  return BannerRepositoryImpl(remoteDatasource: remoteDatasource);
});

// Banner state
class BannerState {
  final bool isLoading;
  final List<BannerEntity> banners;
  final String? error;

  const BannerState({
    this.isLoading = false,
    this.banners = const [],
    this.error,
  });

  const BannerState.initial()
      : isLoading = false,
        banners = const [],
        error = null;

  BannerState copyWith({
    bool? isLoading,
    List<BannerEntity>? banners,
    String? error,
    bool clearError = false,
  }) {
    return BannerState(
      isLoading: isLoading ?? this.isLoading,
      banners: banners ?? this.banners,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// Banner controller
class BannerNotifier extends Notifier<BannerState> {
  @override
  BannerState build() {
    // Listen to auth state to reload on login
    ref.listen(
      authNotifierProvider.select((state) => state.isAuthenticated),
      (previous, next) {
        if (next && previous != next) {
          loadBanners();
        } else if (!next && previous != next) {
          clearBanners();
        }
      },
    );

    // Load banners if authenticated
    Future.microtask(() {
      final isAuthenticated = ref.read(authNotifierProvider).isAuthenticated;
      if (isAuthenticated) {
        loadBanners();
      }
    });

    return const BannerState.initial();
  }

  Future<void> loadBanners() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(bannerRepositoryProvider);
      final banners = await repository.getActiveBanners();

      state = BannerState(
        isLoading: false,
        banners: banners,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refreshBanners() async {
    await loadBanners();
  }

  void clearBanners() {
    state = const BannerState.initial();
  }
}

final bannerNotifierProvider = NotifierProvider<BannerNotifier, BannerState>(() {
  return BannerNotifier();
});

