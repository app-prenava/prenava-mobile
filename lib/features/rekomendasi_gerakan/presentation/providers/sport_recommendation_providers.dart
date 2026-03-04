import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/sport_recommendation_remote_datasource.dart';
import '../../data/repositories/sport_recommendation_repository_impl.dart';
import '../../domain/entities/sport_recommendation.dart';
import '../../domain/repositories/sport_recommendation_repository.dart';

final sportRecommendationDatasourceProvider =
    Provider<SportRecommendationRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return SportRecommendationRemoteDatasource(dio);
});

final sportRecommendationRepositoryProvider =
    Provider<SportRecommendationRepository>((ref) {
  final datasource = ref.watch(sportRecommendationDatasourceProvider);
  return SportRecommendationRepositoryImpl(datasource);
});

class SportRecommendationState {
  final bool isLoading;
  final bool isSubmitting;
  final bool needUpdateData;
  final List<SportRecommendation> recommendations;
  final String? error;
  final String? successMessage;

  const SportRecommendationState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.needUpdateData = false,
    this.recommendations = const [],
    this.error,
    this.successMessage,
  });

  const SportRecommendationState.initial()
      : isLoading = false,
        isSubmitting = false,
        needUpdateData = false,
        recommendations = const [],
        error = null,
        successMessage = null;

  SportRecommendationState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? needUpdateData,
    List<SportRecommendation>? recommendations,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return SportRecommendationState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      needUpdateData: needUpdateData ?? this.needUpdateData,
      recommendations: recommendations ?? this.recommendations,
      error: clearError ? null : (error ?? this.error),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class SportRecommendationNotifier extends Notifier<SportRecommendationState> {
  @override
  SportRecommendationState build() {
    return const SportRecommendationState.initial();
  }

  Future<void> fetchRecommendations() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(sportRecommendationRepositoryProvider);
      final response = await repository.getRecommendations();

      state = state.copyWith(
        isLoading: false,
        needUpdateData: response.needUpdateData ?? false,
        recommendations: response.recommendations,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> submitAssessment(SportAssessmentPayload payload) async {
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final repository = ref.read(sportRecommendationRepositoryProvider);
      final response = await repository.createRecommendation(payload);

      state = state.copyWith(
        isSubmitting: false,
        needUpdateData: false,
        recommendations: response.recommendations,
        successMessage: response.message,
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final sportRecommendationNotifierProvider =
    NotifierProvider<SportRecommendationNotifier, SportRecommendationState>(
  SportRecommendationNotifier.new,
);
