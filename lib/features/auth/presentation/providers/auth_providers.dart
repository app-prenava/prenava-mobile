import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/services/secure_store.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// Datasource provider
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return AuthRemoteDatasource(dio);
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final secureStore = ref.watch(secureStoreProvider);
  return AuthRepositoryImpl(
    remoteDatasource: remoteDatasource,
    secureStore: secureStore,
  );
});

// Auth state
class AuthState {
  final bool isInitialized;
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isInitialized,
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.error,
  });

  const AuthState.initial()
      : isInitialized = false,
        isAuthenticated = false,
        user = null,
        isLoading = false,
        error = null;

  AuthState copyWith({
    bool? isInitialized,
    bool? isAuthenticated,
    User? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isInitialized: isInitialized ?? this.isInitialized,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// Auth controller
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    initialize();
    return const AuthState.initial();
  }

  /// Ensure auth state is loaded from secure storage + backend.
  /// Dipanggil saat startup (SplashScreen) agar user yang sudah
  /// pernah login tidak perlu login ulang selama token masih valid.
  Future<void> initialize() async {
    final repository = ref.read(authRepositoryProvider);

    try {
      final hasValidToken = await repository.hasValidToken();

      if (hasValidToken) {
        final user = await repository.getCurrentUser();
        state = AuthState(
          isInitialized: true,
          isAuthenticated: user != null,
          user: user,
        );
      } else {
        state = const AuthState(
          isInitialized: true,
          isAuthenticated: false,
        );
      }
    } catch (_) {
      state = const AuthState(
        isInitialized: true,
        isAuthenticated: false,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.login(email, password);
      
      state = AuthState(
        isInitialized: true,
        isAuthenticated: true,
        user: user,
        isLoading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
    } finally {
      state = const AuthState(
        isInitialized: true,
        isAuthenticated: false,
      );
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

