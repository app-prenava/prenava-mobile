import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

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
}

