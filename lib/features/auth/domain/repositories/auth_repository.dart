import '../entities/user.dart';

abstract class AuthRepository {
  Future<bool> hasValidToken();
  Future<User?> getCurrentUser();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}

