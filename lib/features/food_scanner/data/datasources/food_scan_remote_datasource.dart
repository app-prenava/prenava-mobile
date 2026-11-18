import 'package:dio/dio.dart';
import '../../../../core/utils/cross_platform_upload.dart';
import '../models/food_scan_result_model.dart';

typedef FoodAsyncProgressCallback = void Function(int progress, String message);

class FoodScanRemoteDatasource {
  final Dio _dio;

  FoodScanRemoteDatasource(this._dio);

  /// Mengirim citra ke V2 Asynchronous AI Gateway (/api/v2/food-scan/async) dengan polling non-blocking,
  /// disertai fallback otomatis ke V1 jika antrean worker sedang pemeliharaan.
  Future<FoodScanApiResponse> analyzePlate(
    String imagePath, {
    FoodAsyncProgressCallback? onProgress,
  }) async {
    try {
      final multipartImage = await createMultipartFileFromPath(imagePath);
      final formData = FormData.fromMap({
        'image': multipartImage,
      });

      onProgress?.call(15, 'Citra piring diterima dan dijadwalkan ke antrean Redis AI...');

      try {
        final asyncResp = await _dio.post(
          '/v2/food-scan/async',
          data: formData,
          options: Options(
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 15),
          ),
        );

        if (asyncResp.statusCode == 202 && asyncResp.data is Map<String, dynamic>) {
          final jobId = asyncResp.data['job_id'] as String?;
          if (jobId != null && jobId.isNotEmpty) {
            return await _pollJobUntilComplete(jobId, imagePath, onProgress: onProgress);
          }
        }
      } on DioException {
        // Fallback ke endpoint sinkron V1 jika V2 belum terjangkau
      }

      return await _analyzePlateSync(imagePath, onProgress: onProgress);
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data is Map ? e.response?.data['message'] : null;
        throw Exception(msg ?? 'Gagal menganalisis piring makanan (${e.response?.statusCode}).');
      }
      throw Exception('Kesalahan jaringan: ${e.message}');
    }
  }

  Future<FoodScanApiResponse> _pollJobUntilComplete(
    String jobId,
    String imagePath, {
    FoodAsyncProgressCallback? onProgress,
  }) async {
    const maxAttempts = 20;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await Future.delayed(const Duration(milliseconds: 1200));

      final statusResp = await _dio.get('/v2/jobs/$jobId/status');
      if (statusResp.statusCode == 200 && statusResp.data is Map<String, dynamic>) {
        final job = statusResp.data['job'] as Map<String, dynamic>?;
        if (job != null) {
          final status = job['status'] as String? ?? 'processing';
          final progress = (job['progress'] as num?)?.toInt() ?? 40;
          final msg = job['message'] as String? ?? 'Mengevaluasi proporsi nutrisi piring...';
          onProgress?.call(progress, msg);

          if (status == 'completed' && job['data'] is Map<String, dynamic>) {
            final jobData = Map<String, dynamic>.from(job['data'] as Map<String, dynamic>);
            jobData['status'] = 'success';
            jobData['message'] = job['message'] ?? 'Analisis gizi piring makan berhasil.';
            return FoodScanApiResponse.fromJson(jobData);
          } else if (status == 'failed') {
            throw Exception(job['error'] ?? 'Gagal memproses segmentasi makanan di worker AI.');
          }
        }
      }
    }

    return await _analyzePlateSync(imagePath, onProgress: onProgress);
  }

  Future<FoodScanApiResponse> _analyzePlateSync(
    String imagePath, {
    FoodAsyncProgressCallback? onProgress,
  }) async {
    onProgress?.call(40, 'Menghubungi layanan ML Food Vision (YOLOv8-seg)...');
    final multipartImage = await createMultipartFileFromPath(imagePath);
    final formData = FormData.fromMap({
      'image': multipartImage,
    });

    onProgress?.call(75, 'Mengevaluasi proporsi 5 kelas nutrisi dan skor triase CDSS...');
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
        onProgress?.call(100, 'Analisis gizi piring makan berhasil.');
        return FoodScanApiResponse.fromJson(data);
      }
      throw Exception('Format respon server tidak valid.');
    } else {
      throw Exception('Gagal menganalisis piring makanan.');
    }
  }
}
