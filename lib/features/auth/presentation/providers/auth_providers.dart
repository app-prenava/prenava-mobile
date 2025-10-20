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

  const AuthState({
    required this.isInitialized,
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
  });

  const AuthState.initial()
      : isInitialized = false,
        isAuthenticated = false,
        user = null,
        isLoading = false;

  AuthState copyWith({
    bool? isInitialized,
    bool? isAuthenticated,
    User? user,
    bool? isLoading,
  }) {
    return AuthState(
      isInitialized: isInitialized ?? this.isInitialized,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Auth controller
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _initialize();
    return const AuthState.initial();
  }

  Future<void> _initialize() async {
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

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.clearToken();
    state = const AuthState(
      isInitialized: true,
      isAuthenticated: false,
    );
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

