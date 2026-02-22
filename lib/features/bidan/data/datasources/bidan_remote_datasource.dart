import 'package:dio/dio.dart';
import '../models/bidan_location_model.dart';

class BidanRemoteDatasource {
  final Dio _dio;

  BidanRemoteDatasource(this._dio);

  // GET /user/bidans/locations - Get all bidan locations (admin-tagged)
  Future<List<BidanLocationModel>> getBidanLocations() async {
    try {
      final response = await _dio.get('/user/bidans/locations');

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        // Handle different response formats
        if (data is Map<String, dynamic>) {
          dynamic rawData = data['data'];
          List<dynamic>? locationsData;

          if (rawData is List) {
            locationsData = rawData;
          } else if (rawData is Map<String, dynamic>) {
            if (rawData.containsKey('data') && rawData['data'] is List) {
              locationsData = rawData['data'] as List<dynamic>;
            } else if (rawData.containsKey('data') && rawData['data'] == null) {
               locationsData = [];
            } else if (rawData.isEmpty) {
              locationsData = [];
            } else {
              locationsData = rawData.values.toList();
            }
          }

          if (locationsData != null) {
            return locationsData
                .map((json) => BidanLocationModel.fromJson(json as Map<String, dynamic>))
                .toList();
          }
        } else if (data is List) {
          return data
              .map((json) => BidanLocationModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load bidan locations');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load bidan locations',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
