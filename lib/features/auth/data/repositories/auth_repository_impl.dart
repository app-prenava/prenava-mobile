import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
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
    try {
      final loginResponse = await _remoteDatasource.login(email, password);
      await _secureStore.write('jwt_token', loginResponse.token);
      return loginResponse.user;
    } catch (e) {
      rethrow;
    }
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
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      final token = await _secureStore.read('jwt_token');
      
      if (token == null || token.isEmpty) {
        return false;
      }

      return await _remoteDatasource.validateToken(token);
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

      return await _remoteDatasource.getCurrentUser(token);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStore.write('jwt_token', token);
  }

  @override
  Future<void> clearToken() async {
    await _secureStore.delete('jwt_token');
  }
}

