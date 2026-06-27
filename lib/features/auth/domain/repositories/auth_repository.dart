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

  // Email verification (registration flow)
  Future<User> verifyEmail(String email, String otp);
  Future<String> resendVerification(String email);

  // Forgot password flow
  Future<String> sendOtp(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<void> resetPassword(String email, String resetToken, String password);

  // Google OAuth
  Future<User> loginWithGoogle(String idToken);
}
