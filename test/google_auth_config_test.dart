import 'package:flutter_test/flutter_test.dart';
import 'package:prenava_mobile/core/config/env.dart';
import 'package:prenava_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:prenava_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prenava_mobile/shared/services/secure_store.dart';

class MockSecureStore implements SecureStore {
  final Map<String, String> data = {};

  @override
  Future<void> write(String key, String value) async => data[key] = value;

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> delete(String key) async => data.remove(key);
}

class MockAuthRemoteDatasource extends Fake implements AuthRemoteDatasource {
  bool logoutCalled = false;

  @override
  Future<void> logout(String token) async {
    logoutCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Google OAuth Configuration Tests', () {
    test('Env contains official Prenava Web Client ID', () {
      expect(
        Env.googleWebClientId,
        '25931493669-vtlgpreroo33hmqvvv0hhhpcnarmn1u6.apps.googleusercontent.com',
      );
    });

    test('Env contains official Prenava Android Client ID', () {
      expect(
        Env.googleAndroidClientId,
        '25931493669-s9up4alhon8p2rj1trb7q0p5imh7hbso.apps.googleusercontent.com',
      );
    });

    test('Env contains official Prenava iOS Client ID', () {
      expect(
        Env.googleIosClientId,
        '25931493669-879hmlbggmtiojjavpnvi840bd10601e.apps.googleusercontent.com',
      );
    });

    test('AuthRepositoryImpl logout clears tokens and handles Google sign out safely', () async {
      final secureStore = MockSecureStore();
      final remoteDatasource = MockAuthRemoteDatasource();
      final repository = AuthRepositoryImpl(
        remoteDatasource: remoteDatasource,
        secureStore: secureStore,
      );

      await secureStore.write('jwt_token', 'active_user_jwt');
      await secureStore.write('cached_user', '{"id": 1, "name": "Ibu"}');

      await repository.logout();

      expect(await secureStore.read('jwt_token'), isNull);
      expect(await secureStore.read('cached_user'), isNull);
      expect(remoteDatasource.logoutCalled, isTrue);
    });
  });
}
