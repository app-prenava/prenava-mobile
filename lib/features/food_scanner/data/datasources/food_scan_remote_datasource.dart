import 'package:dio/dio.dart';
import '../../../../core/utils/cross_platform_upload.dart';
import '../models/food_scan_result_model.dart';

class FoodScanRemoteDatasource {
  final Dio _dio;

  FoodScanRemoteDatasource(this._dio);

  /// POST /api/v1/food-scanner/analyze with image file
  Future<FoodScanApiResponse> analyzePlate(String imagePath) async {
    try {
      final multipartImage = await createMultipartFileFromPath(imagePath);
      final formData = FormData.fromMap({
        'image': multipartImage,
      });

      final response = await _dio.post(
        '/v1/food-scanner/analyze',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return FoodScanApiResponse.fromJson(data);
        }
        throw Exception('Format respon server tidak valid.');
      } else {
        throw Exception('Gagal menganalisis piring makanan.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data is Map ? e.response?.data['message'] : null;
        throw Exception(msg ?? 'Gagal menganalisis piring makanan (${e.response?.statusCode}).');
      }
      throw Exception('Kesalahan jaringan: ${e.message}');
    }
  }
}
