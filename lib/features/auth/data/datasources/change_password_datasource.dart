import 'package:dio/dio.dart';

class ChangePasswordDatasource {
  final Dio _dio;

  ChangePasswordDatasource(this._dio);

  Future<void> changePassword(String newPassword) async {
    try {
      final response = await _dio.put(
        '/auth/change-password',
        data: {'new_password': newPassword},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Validation error
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        if (errors != null && errors.containsKey('new_password')) {
          final messages = errors['new_password'] as List;
          throw Exception(messages.first);
        }
      }
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal mengubah password');
    }
  }
}

