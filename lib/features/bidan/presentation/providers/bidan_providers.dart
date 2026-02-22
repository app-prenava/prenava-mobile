import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/bidan_remote_datasource.dart';
import '../../data/repositories/bidan_repository_impl.dart';
import '../../domain/entities/bidan_location.dart';
import '../../domain/repositories/bidan_repository.dart';

// Datasource provider
final bidanDatasourceProvider = Provider<BidanRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return BidanRemoteDatasource(dio);
});

// Repository provider
final bidanRepositoryProvider = Provider<BidanRepository>((ref) {
  final datasource = ref.watch(bidanDatasourceProvider);
  return BidanRepositoryImpl(datasource);
});

// State class
class BidanLocationState {
  final bool isLoading;
  final List<BidanLocation> bidanLocations;
  final String? error;

  const BidanLocationState({
    this.isLoading = false,
    this.bidanLocations = const [],
    this.error,
  });

  const BidanLocationState.initial()
      : isLoading = false,
        bidanLocations = const [],
        error = null;

  BidanLocationState copyWith({
    bool? isLoading,
    List<BidanLocation>? bidanLocations,
    String? error,
    bool clearError = false,
  }) {
    return BidanLocationState(
      isLoading: isLoading ?? this.isLoading,
      bidanLocations: bidanLocations ?? this.bidanLocations,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// Notifier
class BidanLocationNotifier extends Notifier<BidanLocationState> {
  @override
  BidanLocationState build() {
    Future.microtask(() => loadBidanLocations());
    return const BidanLocationState.initial();
  }

  Future<void> loadBidanLocations() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(bidanRepositoryProvider);
      final locations = await repository.getBidanLocations();

      state = state.copyWith(
        isLoading: false,
        bidanLocations: locations,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// Notifier provider
final bidanLocationNotifierProvider =
    NotifierProvider<BidanLocationNotifier, BidanLocationState>(
        BidanLocationNotifier.new);
