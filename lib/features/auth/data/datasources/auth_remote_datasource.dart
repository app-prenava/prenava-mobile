import 'package:dio/dio.dart';
import '../models/user_model.dart';

class LoginResponse {
  final String token;
  final UserModel user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['authorization']['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return LoginResponse.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Login failed');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email atau password salah');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<UserModel> getCurrentUser(String token) async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to get user data');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('401 Unauthorized');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await _dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout(String token) async {
    try {
      await _dio.post(
        '/auth/logout',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (_) {
      // Ignore logout errors
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; // Success, user needs to login after registration
      }

      throw Exception('Registrasi gagal');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      // Handle validation errors (422)
      if (statusCode == 422) {
        String? message;
        if (data is Map) {
          if (data['message'] is String) {
            message = data['message'] as String;
          } else if (data['errors'] is Map) {
            // Laravel validation errors format
            final errors = data['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first as String;
            }
          }
        }
        throw Exception(message ?? 'Data tidak valid. Mohon periksa kembali.');
      }

      // Handle other errors
      String? message;
      if (data is Map && data['message'] is String) {
        message = data['message'] as String;
      }
      throw Exception(message ?? 'Gagal mendaftar. Silakan coba lagi.');
    }
  }
}

