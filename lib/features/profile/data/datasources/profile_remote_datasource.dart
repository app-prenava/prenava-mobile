import 'package:dio/dio.dart';
import '../models/profile_model.dart';

class ProfileRemoteDatasource {
  final Dio _dio;

  ProfileRemoteDatasource(this._dio);

  Future<ProfileModel?> getProfile() async {
    try {
      final response = await _dio.get('/profile');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('profile') && data['profile'] != null) {
          return ProfileModel.fromJson(data['profile'] as Map<String, dynamic>);
        }
        return ProfileModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<ProfileModel> createProfile(
    Map<String, dynamic> data, {
    String? photoPath,
  }) async {
    try {
      dynamic requestData;

      if (photoPath != null) {
        // Multipart with photo - convert all values to string for FormData
        final formFields = <String, dynamic>{};
        data.forEach((key, value) {
          formFields[key] = value.toString();
        });
        
        requestData = FormData.fromMap({
          ...formFields,
          'photo': await MultipartFile.fromFile(
            photoPath,
            filename: photoPath.split('/').last,
          ),
        });
      } else {
        // JSON only - keep original types
        requestData = data;
      }

      final response = await _dio.post(
        '/profile/create', // Backend endpoint: POST /api/profile/create
        data: requestData,
        options: Options(
          contentType: photoPath != null
              ? 'multipart/form-data'
              : 'application/json',
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('profile')) {
          return ProfileModel.fromJson(responseData['profile'] as Map<String, dynamic>);
        }
        return ProfileModel.fromJson(responseData);
      }

      throw Exception('Failed to create profile');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Profil sudah ada. Gunakan update.');
      }
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal membuat profil');
    }
  }

  Future<ProfileModel> updateProfile(
    Map<String, dynamic> data, {
    String? photoPath,
  }) async {
    try {
      dynamic requestData;

      if (photoPath != null) {
        // Multipart with photo - convert all values to string for FormData
        final formFields = <String, dynamic>{};
        data.forEach((key, value) {
          formFields[key] = value.toString();
        });
        
        requestData = FormData.fromMap({
          ...formFields,
          'photo': await MultipartFile.fromFile(
            photoPath,
            filename: photoPath.split('/').last,
          ),
        });
      } else {
        // JSON only - keep original types
        requestData = data;
      }

      final response = await _dio.post( // Changed from PUT to POST
        '/profile/update', // Backend endpoint: POST /api/profile/update
        data: requestData,
        options: Options(
          contentType: photoPath != null
              ? 'multipart/form-data'
              : 'application/json',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('profile')) {
          return ProfileModel.fromJson(responseData['profile'] as Map<String, dynamic>);
        }
        return ProfileModel.fromJson(responseData);
      }

      throw Exception('Failed to update profile');
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal mengupdate profil');
    }
  }

  Future<void> deletePhoto() async {
    try {
      await _dio.delete('/profile/photo');
    } on DioException catch (e) {
      final message = e.response?.data['message'] as String?;
      throw Exception(message ?? 'Gagal menghapus foto');
    }
  }
}

