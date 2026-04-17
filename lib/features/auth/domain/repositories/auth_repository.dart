import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<bool> hasValidToken();
  Future<User?> getCurrentUser();
  Future<void> saveToken(String token);
  Future<void> clearToken();
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
  Future<String> sendOtp(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<void> resetPassword(String email, String resetToken, String password);
}

