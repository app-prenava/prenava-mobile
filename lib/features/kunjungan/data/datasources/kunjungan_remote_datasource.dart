import 'package:dio/dio.dart';
import '../models/visit_model.dart';

class KunjunganRemoteDatasource {
  final Dio _dio;

  KunjunganRemoteDatasource(this._dio);

  // GET /api/catatan-ibu - Get all visits
  Future<List<VisitModel>> getVisits() async {
    try {
      final response = await _dio.get('/catatan-ibu');

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          final visitsData = data['data'] as List<dynamic>?;
          if (visitsData != null) {
            return visitsData
                .map((json) => VisitModel.fromJson(json as Map<String, dynamic>))
                .toList();
          }
        } else if (data is List) {
          return data
              .map((json) => VisitModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load visits');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load visits',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // GET /api/catatan-ibu/:id - Get visit detail
  Future<VisitModel> getVisitById(int id) async {
    try {
      final response = await _dio.get('/catatan-ibu/$id');

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          // Check if wrapped in 'data' key
          final wrappedData = data['data'] as Map<String, dynamic>?;
          if (wrappedData != null) {
            return VisitModel.fromJson(wrappedData);
          }
          // Direct object
          return VisitModel.fromJson(data);
        } else if (data is List) {
          // API returned a list instead of single object
          if (data.isNotEmpty) {
            return VisitModel.fromJson(data.first as Map<String, dynamic>);
          } else {
            throw Exception('No visit found with id: $id');
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load visit details');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load visit details',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // POST /api/catatan-ibu - Create new visit
  Future<VisitModel> createVisit({
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  }) async {
    try {
      // Convert pertanyaan to Laravel format (individual columns)
      final pertanyaanJson = <String, dynamic>{};
      pertanyaan.forEach((key, value) {
        // Convert boolean to int (1/0/null) for Laravel columns
        pertanyaanJson[key] = value == null ? null : (value ? 1 : 0);
      });

      final response = await _dio.post(
        '/catatan-ibu',
        data: {
          'tanggal_kunjungan': tanggalKunjungan.toIso8601String(),
          ...pertanyaanJson, // Spread individual q1_demam, q2_pusing, etc.
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          // Check if wrapped in 'data' key
          final wrappedData = data['data'] as Map<String, dynamic>?;
          if (wrappedData != null) {
            return VisitModel.fromJson(wrappedData);
          }
          // Direct object
          return VisitModel.fromJson(data);
        } else if (data is List) {
          // API returned a list
          if (data.isNotEmpty) {
            return VisitModel.fromJson(data.first as Map<String, dynamic>);
          } else {
            throw Exception('Failed to create visit - empty response');
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to create visit');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to create visit',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // PUT /api/catatan-ibu/:id - Update visit
  Future<VisitModel> updateVisit({
    required int id,
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  }) async {
    try {
      // Convert pertanyaan to Laravel format (individual columns)
      final pertanyaanJson = <String, dynamic>{};
      pertanyaan.forEach((key, value) {
        // Convert boolean to int (1/0/null) for Laravel columns
        pertanyaanJson[key] = value == null ? null : (value ? 1 : 0);
      });

      final response = await _dio.put(
        '/catatan-ibu/$id',
        data: {
          'tanggal_kunjungan': tanggalKunjungan.toIso8601String(),
          ...pertanyaanJson, // Spread individual q1_demam, q2_pusing, etc.
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          // Check if wrapped in 'data' key
          final wrappedData = data['data'] as Map<String, dynamic>?;
          if (wrappedData != null) {
            return VisitModel.fromJson(wrappedData);
          }
          // Direct object
          return VisitModel.fromJson(data);
        } else if (data is List) {
          // API returned a list
          if (data.isNotEmpty) {
            return VisitModel.fromJson(data.first as Map<String, dynamic>);
          } else {
            throw Exception('Failed to update visit - empty response');
          }
        }

        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to update visit');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to update visit',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // DELETE /api/catatan-ibu/:id - Delete visit
  Future<void> deleteVisit(int id) async {
    try {
      final response = await _dio.delete('/catatan-ibu/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete visit');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to delete visit',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
