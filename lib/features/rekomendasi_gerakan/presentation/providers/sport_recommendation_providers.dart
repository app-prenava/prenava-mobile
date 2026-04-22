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
  final bool needsLmp;
  final bool needsProfile;
  final Map<String, dynamic>? existingAssessment;

  const SportRecommendationState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.needUpdateData = false,
    this.recommendations = const [],
    this.error,
    this.successMessage,
    this.needsLmp = false,
    this.needsProfile = false,
    this.existingAssessment,
  });

  const SportRecommendationState.initial()
    : isLoading = false,
      isSubmitting = false,
      needUpdateData = false,
      recommendations = const [],
      error = null,
      successMessage = null,
      needsLmp = false,
      needsProfile = false,
      existingAssessment = null;

  SportRecommendationState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? needUpdateData,
    List<SportRecommendation>? recommendations,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    bool? needsLmp,
    bool? needsProfile,
    Map<String, dynamic>? existingAssessment,
    bool clearAssessment = false,
  }) {
    return SportRecommendationState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      needUpdateData: needUpdateData ?? this.needUpdateData,
      recommendations: recommendations ?? this.recommendations,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      needsLmp: needsLmp ?? this.needsLmp,
      needsProfile: needsProfile ?? this.needsProfile,
      existingAssessment: clearAssessment
          ? null
          : (existingAssessment ?? this.existingAssessment),
    );
  }
}

class SportRecommendationNotifier extends Notifier<SportRecommendationState> {
  @override
  SportRecommendationState build() {
    return const SportRecommendationState.initial();
  }

  Future<void> fetchRecommendations() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      needsLmp: false,
      needsProfile: false,
    );

    try {
      final repository = ref.read(sportRecommendationRepositoryProvider);
      final response = await repository.getRecommendations();

      state = state.copyWith(
        isLoading: false,
        needUpdateData: response.needUpdateData ?? false,
        recommendations: response.recommendations,
      );
    } catch (e) {
      final errorStr = e.toString().replaceAll('Exception: ', '');
      final errorMsg = errorStr.toLowerCase();
      final needsLmp =
          errorMsg.contains('lmp') || errorMsg.contains('pregnancy');
      final needsProfile = errorMsg.contains('tanggal lahir tidak ditemukan');

      state = state.copyWith(
        isLoading: false,
        error: errorStr,
        needsLmp: needsLmp,
        needsProfile: needsProfile,
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
      final errorStr = e.toString().replaceAll('Exception: ', '');

      // If ML service fails, fall back to all sports from admin
      if (errorStr.contains('predict') ||
          errorStr.contains('ML') ||
          errorStr.contains('cURL')) {
        await _fetchAllSportsFallback();
      } else {
        state = state.copyWith(isSubmitting: false, error: errorStr);
      }
    }
  }

  Future<void> _fetchAllSportsFallback() async {
    try {
      final repository = ref.read(sportRecommendationRepositoryProvider);
      final allSports = await repository.getAllSports();

      state = state.copyWith(
        isSubmitting: false,
        recommendations: allSports,
        successMessage: 'Menampilkan semua olahraga dari admin',
      );
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> fetchExistingAssessment() async {
    try {
      final repository = ref.read(sportRecommendationRepositoryProvider);
      final existing = await repository.getExistingAssessment();
      if (existing != null) {
        state = state.copyWith(existingAssessment: existing);
      }
    } catch (_) {
      // Silently fail — form will just show defaults
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
