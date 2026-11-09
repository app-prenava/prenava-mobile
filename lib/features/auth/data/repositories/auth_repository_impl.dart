import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../../../shared/services/secure_store.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SecureStore _secureStore;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required SecureStore secureStore,
  })  : _remoteDatasource = remoteDatasource,
        _secureStore = secureStore;

  @override
  Future<User> login(String email, String password) async {
    // RequiresVerificationException is intentionally NOT caught here
    // so the provider layer can handle navigation to OTP screen.
    final loginResponse = await _remoteDatasource.login(email, password);
    await _secureStore.write('jwt_token', loginResponse.token);
    await _saveCachedUser(loginResponse.user);
    return loginResponse.user;
  }

  @override
  Future<void> logout() async {
    try {
      final token = await _secureStore.read('jwt_token');
      if (token != null) {
        await _remoteDatasource.logout(token);
      }
    } finally {
      await _secureStore.delete('jwt_token');
      await _secureStore.delete('cached_user');
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Ignore Google signOut errors if no active Google session
      }
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      final token = await _secureStore.read('jwt_token');
      
      if (token == null || token.isEmpty) {
        return false;
      }

      // Token exists locally - trust it and let API calls handle 401 if invalid
      // This prevents logout on network errors during app startup
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await _secureStore.read('jwt_token');
      
      if (token == null || token.isEmpty) {
        return null;
      }

      try {
        final remoteUser = await _remoteDatasource.getCurrentUser(token);
        await _saveCachedUser(remoteUser);
        return remoteUser;
      } catch (e) {
        final errStr = e.toString();
        if (errStr.contains('401') || errStr.contains('Unauthorized')) {
          await clearToken();
          return null;
        }

        // On network error or offline, fallback to cached user session
        final cached = await _getCachedUser();
        if (cached != null) {
          return cached;
        }
        return null;
      }
    } catch (_) {
      return await _getCachedUser();
    }
  }

  Future<void> _saveCachedUser(User user) async {
    try {
      final model = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        category: user.category,
      );
      await _secureStore.write('cached_user', jsonEncode(model.toJson()));
    } catch (_) {}
  }

  Future<User?> _getCachedUser() async {
    try {
      final jsonStr = await _secureStore.read('cached_user');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        return UserModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStore.write('jwt_token', token);
  }

  @override
  Future<void> clearToken() async {
    await _secureStore.delete('jwt_token');
    await _secureStore.delete('cached_user');
      try {
        await GoogleSignIn().signOut();
      } catch (_) {
        // Ignore Google signOut errors if no active Google session
      }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _remoteDatasource.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> verifyEmail(String email, String otp) async {
    final loginResponse = await _remoteDatasource.verifyEmail(email, otp);
    await _secureStore.write('jwt_token', loginResponse.token);
    await _saveCachedUser(loginResponse.user);
    return loginResponse.user;
  }

  @override
  Future<String> resendVerification(String email) async {
    return await _remoteDatasource.resendVerification(email);
  }

  @override
  Future<String> sendOtp(String email) async {
    try {
      return await _remoteDatasource.sendOtp(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    try {
      return await _remoteDatasource.verifyOtp(email, otp);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email, String resetToken, String password) async {
    try {
      await _remoteDatasource.resetPassword(email, resetToken, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> loginWithGoogle(String idToken) async {
    try {
      final loginResponse = await _remoteDatasource.loginWithGoogle(idToken);
      await _secureStore.write('jwt_token', loginResponse.token);
      await _saveCachedUser(loginResponse.user);
      return loginResponse.user;
    } catch (e) {
      rethrow;
    }
  }
}
