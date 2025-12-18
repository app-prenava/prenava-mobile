import 'package:dio/dio.dart';
import '../models/water_intake_response_model.dart';
import '../models/water_intake_store_response_model.dart';

class HydrationRemoteDatasource {
  final Dio _dio;

  HydrationRemoteDatasource(this._dio);

  // GET /api/water-intake - Ambil data harian + statistik 7 hari
  Future<WaterIntakeResponseModel> getWaterIntake() async {
    try {
      final response = await _dio.get('/water-intake');

      if (response.statusCode == 200) {
        return WaterIntakeResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load water intake data');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to load water intake data',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  // POST /api/water-intake - Tambah konsumsi air (250ml default)
  Future<WaterIntakeStoreResponseModel> addWaterIntake({
    int jumlahMl = 250,
  }) async {
    try {
      final response = await _dio.post(
        '/water-intake',
        data: {'jumlah_ml': jumlahMl},
      );

      if (response.statusCode == 201) {
        return WaterIntakeStoreResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else if (response.statusCode == 400) {
        // Target sudah tercapai
        throw Exception(
          response.data['message'] ?? 'Batas konsumsi tercapai',
        );
      } else {
        throw Exception('Failed to save water intake');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Failed to save water intake',
        );
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}

