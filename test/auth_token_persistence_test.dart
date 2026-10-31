import 'package:flutter_test/flutter_test.dart';
import 'package:prenava_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:prenava_mobile/features/auth/data/models/user_model.dart';
import 'package:prenava_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prenava_mobile/features/auth/domain/entities/user.dart';
import 'package:prenava_mobile/shared/services/secure_store.dart';

class FakeSecureStore implements SecureStore {
  final Map<String, String> _data = {};

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return _data[key];
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }
}

class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  bool shouldThrow401 = false;
  bool shouldThrowNetworkError = false;
  UserModel mockUser = const UserModel(
    id: 101,
    name: 'Ibu Rahma',
    email: 'rahma@prenava.com',
    category: 'ibu_hamil',
  );

  @override
  Future<LoginResponse> login(String email, String password) async {
    return LoginResponse(token: 'mock_jwt_30_days', user: mockUser);
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    if (shouldThrow401) {
      throw Exception('401 Unauthorized');
    }
    if (shouldThrowNetworkError) {
      throw Exception('Network error: Connection refused');
    }
    return mockUser;
  }

  @override
  Future<void> logout(String token) async {}

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {}

  @override
  Future<LoginResponse> verifyEmail(String email, String otp) async {
    return LoginResponse(token: 'mock_jwt_30_days', user: mockUser);
  }

  @override
  Future<String> resendVerification(String email) async => 'Sent';

  @override
  Future<String> sendOtp(String email) async => 'Sent';

  @override
  Future<String> verifyOtp(String email, String otp) async => 'Verified';

  @override
  Future<void> resetPassword(String email, String resetToken, String password) async {}

  @override
  Future<LoginResponse> loginWithGoogle(String idToken) async {
    return LoginResponse(token: 'mock_jwt_google', user: mockUser);
  }

  @override
  Future<bool> validateToken(String token) async => true;
}

void main() {
  group('Auth Token & Session Persistence Tests', () {
    late FakeSecureStore secureStore;
    late FakeAuthRemoteDatasource remoteDatasource;
    late AuthRepositoryImpl repository;

    setUp(() {
      secureStore = FakeSecureStore();
      remoteDatasource = FakeAuthRemoteDatasource();
      repository = AuthRepositoryImpl(
        remoteDatasource: remoteDatasource,
        secureStore: secureStore,
      );
    });

    test('Login saves both jwt_token and cached_user in secure storage', () async {
      final user = await repository.login('rahma@prenava.com', 'password123');

      expect(user.id, 101);
      expect(user.name, 'Ibu Rahma');

      final token = await secureStore.read('jwt_token');
      expect(token, 'mock_jwt_30_days');

      final cachedJson = await secureStore.read('cached_user');
      expect(cachedJson, isNotNull);
      expect(cachedJson!.contains('Ibu Rahma'), isTrue);
    });

    test('hasValidToken returns true when jwt_token exists locally', () async {
      expect(await repository.hasValidToken(), isFalse);

      await repository.login('rahma@prenava.com', 'password123');
      expect(await repository.hasValidToken(), isTrue);
    });

    test('getCurrentUser falls back to cached user during network/offline errors', () async {
      // First login to populate session & cache
      await repository.login('rahma@prenava.com', 'password123');

      // Simulate app reopen when offline or backend unreachable
      remoteDatasource.shouldThrowNetworkError = true;

      final restoredUser = await repository.getCurrentUser();
      expect(restoredUser, isNotNull);
      expect(restoredUser!.id, 101);
      expect(restoredUser.email, 'rahma@prenava.com');

      // Token should NOT be wiped on network errors
      expect(await repository.hasValidToken(), isTrue);
    });

    test('getCurrentUser wipes token and cache when backend explicitly returns 401', () async {
      await repository.login('rahma@prenava.com', 'password123');

      // Simulate backend rejecting revoked or expired token
      remoteDatasource.shouldThrow401 = true;

      final user = await repository.getCurrentUser();
      expect(user, isNull);

      // Session and token must be cleanly cleared
      expect(await secureStore.read('jwt_token'), isNull);
      expect(await secureStore.read('cached_user'), isNull);
      expect(await repository.hasValidToken(), isFalse);
    });

    test('logout cleanly clears both jwt_token and cached_user', () async {
      await repository.login('rahma@prenava.com', 'password123');
      expect(await secureStore.read('jwt_token'), isNotNull);
      expect(await secureStore.read('cached_user'), isNotNull);

      await repository.logout();
      expect(await secureStore.read('jwt_token'), isNull);
      expect(await secureStore.read('cached_user'), isNull);
    });
  });
}
