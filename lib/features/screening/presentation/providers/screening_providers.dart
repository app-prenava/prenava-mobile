import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/presentation/providers/daily_features_provider.dart';
import '../../data/datasources/screening_remote_datasource.dart';
import '../../data/models/screening_models.dart';

final screeningDatasourceProvider = Provider<ScreeningRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return ScreeningRemoteDatasource(dio);
});

class ScreeningState {
  final bool isLoading;
  final bool isLoaded;
  final ScreeningResultModel? latest;
  final String? error;

  const ScreeningState({
    this.isLoading = false,
    this.isLoaded = false,
    this.latest,
    this.error,
  });

  bool get hasCompletedScreening => latest?.hasCompletedScreening == true;

  ScreeningState copyWith({
    bool? isLoading,
    bool? isLoaded,
    ScreeningResultModel? latest,
    bool clearLatest = false,
    String? error,
    bool clearError = false,
  }) {
    return ScreeningState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
      latest: clearLatest ? null : (latest ?? this.latest),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ScreeningNotifier extends Notifier<ScreeningState> {
  @override
  ScreeningState build() => const ScreeningState();

  Future<ScreeningResultModel?> loadLatest() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final datasource = ref.read(screeningDatasourceProvider);
      final result = await datasource.getLatest();
      state = ScreeningState(
        isLoading: false,
        isLoaded: true,
        latest: result,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoaded: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<ScreeningResultModel?> submitScreening({
    required String version,
    required Map<int, String> answers,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final datasource = ref.read(screeningDatasourceProvider);
      final result = await datasource.submitScreening(
        version: version,
        answers: answers,
      );
      state = ScreeningState(
        isLoading: false,
        isLoaded: true,
        latest: result,
      );
      // Refresh daily progress so category-based daily tasks update immediately
      ref.invalidate(dailyProgressProvider);
      ref.invalidate(screeningHistoryProvider);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  void clear() {
    state = const ScreeningState();
  }
}

final screeningNotifierProvider =
    NotifierProvider<ScreeningNotifier, ScreeningState>(ScreeningNotifier.new);

final screeningQuestionsProvider =
    FutureProvider.autoDispose<ScreeningQuestionsResponse>((ref) async {
  final datasource = ref.watch(screeningDatasourceProvider);
  return datasource.getQuestions();
});

final screeningHistoryProvider =
    FutureProvider.autoDispose<ScreeningHistoryResponse>((ref) async {
  final datasource = ref.watch(screeningDatasourceProvider);
  return datasource.getHistory();
});
