import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

// Datasource provider
final profileRemoteDatasourceProvider = Provider<ProfileRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return ProfileRemoteDatasource(dio);
});

// Repository provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDatasource = ref.watch(profileRemoteDatasourceProvider);
  return ProfileRepositoryImpl(remoteDatasource: remoteDatasource);
});

// Profile state
class ProfileState {
  final bool isLoading;
  final Profile? profile;
  final bool hasProfile;
  final String? error;
  final String? successMessage;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.hasProfile = false,
    this.error,
    this.successMessage,
  });

  const ProfileState.initial()
      : isLoading = false,
        profile = null,
        hasProfile = false,
        error = null,
        successMessage = null;

  ProfileState copyWith({
    bool? isLoading,
    Profile? profile,
    bool? hasProfile,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      hasProfile: hasProfile ?? this.hasProfile,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

// Profile controller
class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    // Schedule loadProfile to run after build completes
    Future.microtask(() => loadProfile());
    return const ProfileState.initial();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);
      final profile = await repository.getProfile();

      state = ProfileState(
        isLoading: false,
        profile: profile,
        hasProfile: profile != null,
      );
    } catch (e) {
      // Silently fail - user can still use the form to create profile
      state = state.copyWith(
        isLoading: false,
        hasProfile: false,
        // Don't show error - just let user fill the form
      );
    }
  }

  Future<bool> saveProfile(
    Map<String, dynamic> data, {
    String? photoPath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(profileRepositoryProvider);
      Profile updatedProfile;

      // Try CREATE first (POST)
      try {
        updatedProfile = await repository.createProfile(data, photoPath: photoPath);
      } catch (createError) {
        final errorMsg = createError.toString();
        
        // If profile already exists (405 or 409), try UPDATE
        if (errorMsg.contains('405') || 
            errorMsg.contains('409') || 
            errorMsg.contains('Method Not Allowed') ||
            errorMsg.contains('sudah ada')) {
          // Profile exists, use UPDATE instead
          updatedProfile = await repository.updateProfile(data, photoPath: photoPath);
        } else {
          rethrow;
        }
      }

      state = ProfileState(
        isLoading: false,
        profile: updatedProfile,
        hasProfile: true,
        successMessage: 'Profil berhasil disimpan',
      );

      return true;
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // Provide user-friendly error messages
      if (errorMessage.contains('500')) {
        errorMessage = 'Terjadi kesalahan di server. Silakan hubungi administrator.';
      } else if (errorMessage.contains('405')) {
        errorMessage = 'Fitur ini belum tersedia. Backend perlu dikonfigurasi.';
      } else if (errorMessage.contains('401') || errorMessage.contains('403')) {
        errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return false;
    }
  }

  Future<void> deletePhoto() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.deletePhoto();
      await loadProfile(); // Reload profile
      
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Foto berhasil dihapus',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}

final profileNotifierProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});

