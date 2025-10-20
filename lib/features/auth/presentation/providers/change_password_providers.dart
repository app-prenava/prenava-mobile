import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/change_password_datasource.dart';
import '../../data/repositories/change_password_repository_impl.dart';
import '../../domain/repositories/change_password_repository.dart';

// Datasource provider
final changePasswordDatasourceProvider = Provider<ChangePasswordDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return ChangePasswordDatasource(dio);
});

// Repository provider
final changePasswordRepositoryProvider = Provider<ChangePasswordRepository>((ref) {
  final datasource = ref.watch(changePasswordDatasourceProvider);
  return ChangePasswordRepositoryImpl(datasource: datasource);
});

// State for Change Password
class ChangePasswordState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const ChangePasswordState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  const ChangePasswordState.initial()
      : isLoading = false,
        error = null,
        successMessage = null;

  ChangePasswordState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

// Notifier for Change Password
class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() {
    return const ChangePasswordState.initial();
  }

  Future<bool> changePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(changePasswordRepositoryProvider);
      await repository.changePassword(newPassword);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password berhasil diubah. Silakan login kembali.',
      );

      return true;
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );

      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final changePasswordNotifierProvider =
    NotifierProvider<ChangePasswordNotifier, ChangePasswordState>(() {
  return ChangePasswordNotifier();
});

