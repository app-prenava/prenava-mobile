import 'package:dio/dio.dart';
import '../models/pregnancy_model.dart';

class PregnancyRemoteDatasource {
  final Dio _dio;

  PregnancyRemoteDatasource(this._dio);

  // Calculate HPL without saving to database
  Future<PregnancyModel> calculatePregnancy({
    required String hpht,
  }) async {
    try {
      final response = await _dio.post(
        '/pregnancy-calculator/calculate',
        data: {
          'hpht': hpht,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        return PregnancyModel.fromJson(data);
      }

      throw Exception('Gagal menghitung HPL');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghitung HPL');
    }
  }

  // Get my pregnancy data
  Future<PregnancyModel?> getMyPregnancy() async {
    try {
      final response = await _dio.get('/pregnancy-calculator/my');

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data'] != null) {
          return PregnancyModel.fromJson(response.data['data'] as Map<String, dynamic>);
        }
        return null;
      }

      return null;
    } on DioException catch (e) {
      // Handle 404 gracefully - return null when no pregnancy data exists
      if (e.response?.statusCode == 404) {
        return null;
      }
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil data kehamilan');
    }
  }

  // Save pregnancy data
  Future<PregnancyModel> savePregnancy({
    required String hpht,
    String? babyName,
    String? babyGender,
  }) async {
    try {
      final data = <String, dynamic>{
        'hpht': hpht,
      };

      // Only include baby name and gender if they are provided
      if (babyName != null && babyName.isNotEmpty) {
        data['baby_name'] = babyName;
      }
      if (babyGender != null && babyGender.isNotEmpty) {
        data['baby_gender'] = babyGender;
      }

      final response = await _dio.post(
        '/pregnancy-calculators',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'] as Map<String, dynamic>;
        return PregnancyModel.fromJson(responseData);
      }

      throw Exception('Gagal menyimpan data kehamilan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menyimpan data kehamilan');
    }
  }

  // Update pregnancy data
  Future<PregnancyModel> updatePregnancy({
    required int id,
    required String hpht,
    String? babyName,
    String? babyGender,
  }) async {
    try {
      final data = <String, dynamic>{
        'hpht': hpht,
      };

      if (babyName != null && babyName.isNotEmpty) {
        data['baby_name'] = babyName;
      }
      if (babyGender != null && babyGender.isNotEmpty) {
        data['baby_gender'] = babyGender;
      }

      final response = await _dio.put(
        '/pregnancy-calculators/$id',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'] as Map<String, dynamic>;
        return PregnancyModel.fromJson(responseData);
      }

      throw Exception('Gagal mengupdate data kehamilan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengupdate data kehamilan');
    }
  }

  // Update pregnancy health status by bidan
  Future<PregnancyModel> updateHealthStatus({
    required int id,
    required bool isHighRisk,
    required bool hasDiabetes,
    required bool hasHypertension,
    required bool hasAnemia,
    required bool needsSpecialCare,
    required String notes,
  }) async {
    try {
      final response = await _dio.put(
        '/pregnancy-calculators/$id/health-status',
        data: {
          'is_high_risk': isHighRisk,
          'has_diabetes': hasDiabetes,
          'has_hypertension': hasHypertension,
          'has_anemia': hasAnemia,
          'needs_special_care': needsSpecialCare,
          'notes': notes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data['data'] as Map<String, dynamic>;
        return PregnancyModel.fromJson(responseData);
      }

      throw Exception('Gagal mengupdate status kesehatan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengupdate status kesehatan');
    }
  }
}
