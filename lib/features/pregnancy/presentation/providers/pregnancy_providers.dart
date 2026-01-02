import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/pregnancy_remote_datasource.dart';
import '../../data/repositories/pregnancy_repository_impl.dart';
import '../../domain/entities/pregnancy.dart';
import '../../domain/repositories/pregnancy_repository.dart';

// Datasource provider
final pregnancyDatasourceProvider = Provider<PregnancyRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return PregnancyRemoteDatasource(dio);
});

// Repository provider
final pregnancyRepositoryProvider = Provider<PregnancyRepository>((ref) {
  final datasource = ref.watch(pregnancyDatasourceProvider);
  return PregnancyRepositoryImpl(remoteDatasource: datasource);
});

// ==================== Pregnancy State ====================

class PregnancyState {
  final bool isLoading;
  final bool isCalculating;
  final bool isSaving;
  final Pregnancy? pregnancy;
  final String? error;
  final String? successMessage;

  const PregnancyState({
    this.isLoading = false,
    this.isCalculating = false,
    this.isSaving = false,
    this.pregnancy,
    this.error,
    this.successMessage,
  });

  const PregnancyState.initial()
      : isLoading = false,
        isCalculating = false,
        isSaving = false,
        pregnancy = null,
        error = null,
        successMessage = null;

  PregnancyState copyWith({
    bool? isLoading,
    bool? isCalculating,
    bool? isSaving,
    Pregnancy? pregnancy,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return PregnancyState(
      isLoading: isLoading ?? this.isLoading,
      isCalculating: isCalculating ?? this.isCalculating,
      isSaving: isSaving ?? this.isSaving,
      pregnancy: pregnancy ?? this.pregnancy,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

// ==================== Pregnancy Notifier ====================

class PregnancyNotifier extends Notifier<PregnancyState> {
  @override
  PregnancyState build() {
    // Load pregnancy data when authenticated
    ref.listen(
      authNotifierProvider.select((state) => state.isAuthenticated),
      (previous, next) {
        if (next && previous != next) {
          loadMyPregnancy();
        } else if (!next && previous != next) {
          state = const PregnancyState.initial();
        }
      },
    );

    // Load pregnancy if authenticated
    Future.microtask(() {
      final isAuthenticated = ref.read(authNotifierProvider).isAuthenticated;
      if (isAuthenticated) {
        loadMyPregnancy();
      }
    });

    return const PregnancyState.initial();
  }

  // Load my pregnancy data
  Future<void> loadMyPregnancy() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(pregnancyRepositoryProvider);
      final pregnancy = await repository.getMyPregnancy();

      state = state.copyWith(
        isLoading: false,
        pregnancy: pregnancy,
      );
    } catch (e) {
      // If user hasn't set pregnancy data yet, it's not an error
      if (e.toString().contains('404') ||
          e.toString().contains('belum ada') ||
          e.toString().contains('belum diisi')) {
        state = state.copyWith(isLoading: false, pregnancy: null);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString().replaceAll('Exception: ', ''),
        );
      }
    }
  }

  // Calculate HPL without saving
  Future<void> calculatePregnancy({required String hpht}) async {
    state = state.copyWith(isCalculating: true, clearError: true);

    try {
      final repository = ref.read(pregnancyRepositoryProvider);
      final pregnancy = await repository.calculatePregnancy(hpht: hpht);

      state = state.copyWith(
        isCalculating: false,
        pregnancy: pregnancy,
      );
    } catch (e) {
      state = state.copyWith(
        isCalculating: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Save pregnancy data
  Future<bool> savePregnancy({
    required String hpht,
    String? babyName,
    String? babyGender,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(pregnancyRepositoryProvider);
      final pregnancy = await repository.savePregnancy(
        hpht: hpht,
        babyName: babyName,
        babyGender: babyGender,
      );

      state = state.copyWith(
        isSaving: false,
        pregnancy: pregnancy,
        successMessage: 'Data kehamilan berhasil disimpan',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Update pregnancy data
  Future<bool> updatePregnancy({
    required String hpht,
    String? babyName,
    String? babyGender,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(pregnancyRepositoryProvider);
      final pregnancy = state.pregnancy;

      if (pregnancy == null) {
        state = state.copyWith(
          isSaving: false,
          error: 'Tidak ada data kehamilan yang diupdate',
        );
        return false;
      }

      // Extract ID from pregnancy data if available
      final updatedPregnancy = await repository.updatePregnancy(
        id: 1, // TODO: Get actual pregnancy ID
        hpht: hpht,
        babyName: babyName,
        babyGender: babyGender,
      );

      state = state.copyWith(
        isSaving: false,
        pregnancy: updatedPregnancy,
        successMessage: 'Data kehamilan berhasil diupdate',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Update health status by bidan
  Future<bool> updateHealthStatus({
    required int id,
    required bool isHighRisk,
    required bool hasDiabetes,
    required bool hasHypertension,
    required bool hasAnemia,
    required bool needsSpecialCare,
    required String notes,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(pregnancyRepositoryProvider);
      final updatedPregnancy = await repository.updateHealthStatus(
        id: id,
        isHighRisk: isHighRisk,
        hasDiabetes: hasDiabetes,
        hasHypertension: hasHypertension,
        hasAnemia: hasAnemia,
        needsSpecialCare: needsSpecialCare,
        notes: notes,
      );

      state = state.copyWith(
        isSaving: false,
        pregnancy: updatedPregnancy,
        successMessage: 'Status kesehatan berhasil diupdate',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  // Clear messages
  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final pregnancyNotifierProvider =
    NotifierProvider<PregnancyNotifier, PregnancyState>(PregnancyNotifier.new);
