import 'package:dio/dio.dart';
import '../models/depression_scan_result_model.dart';

class DepressionScanRemoteDatasource {
  final Dio _dio;

  DepressionScanRemoteDatasource(this._dio);

  /// POST /api/depression-scan with image file
  Future<DepressionScanResultModel> scanFace(String imagePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/depression-scan',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return DepressionScanResultModel.fromJson(data);
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to scan face');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg =
            e.response?.data is Map ? e.response?.data['message'] : null;
        throw Exception(msg ?? 'Failed to scan face');
      }
      throw Exception('Network error: ${e.message}');
    }
  }
}
