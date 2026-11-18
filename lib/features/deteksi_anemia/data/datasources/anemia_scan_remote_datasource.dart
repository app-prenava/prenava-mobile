import 'package:dio/dio.dart';
import '../../../../core/utils/cross_platform_upload.dart';
import '../models/anemia_scan_result_model.dart';

typedef AsyncJobProgressCallback = void Function(int progress, String message);

class AnemiaScanRemoteDatasource {
  final Dio _dio;

  AnemiaScanRemoteDatasource(this._dio);

  /// Mengirim citra ke V2 Asynchronous AI Gateway (Redis Queue) dengan polling non-blocking,
  /// disertai fallback otomatis ke V1 jika worker antrean sedang pemeliharaan.
  Future<AnemiaScanResultModel> scanEye(
    String imagePath, {
    AsyncJobProgressCallback? onProgress,
  }) async {
    try {
      final multipartImage = await createMultipartFileFromPath(imagePath);
      final formData = FormData.fromMap({
        'image': multipartImage,
      });

      onProgress?.call(15, 'Citra diterima dan dijadwalkan ke antrean Redis AI...');

      try {
        final asyncResp = await _dio.post(
          '/v2/anemia-scan/async',
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
        // Fallback ke endpoint sinkron V1 jika endpoint V2 belum terjangkau
      }

      return await _scanEyeSync(imagePath, onProgress: onProgress);
    } on DioException catch (e) {
      if (e.response != null) {
        final msg =
            e.response?.data is Map ? e.response?.data['message'] : null;
        throw Exception(msg ?? 'Failed to scan anemia');
      }
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<AnemiaScanResultModel> _pollJobUntilComplete(
    String jobId,
    String imagePath, {
    AsyncJobProgressCallback? onProgress,
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
          final msg = job['message'] as String? ?? 'Memproses inferensi AI...';
          onProgress?.call(progress, msg);

          if (status == 'completed') {
            final payload = <String, dynamic>{
              'status': 'success',
              'data': job['data'],
              'history': job['history'],
            };
            return AnemiaScanResultModel.fromJson(payload);
          } else if (status == 'failed') {
            throw Exception(job['error'] ?? 'Gagal memproses citra di worker AI.');
          }
        }
      }
    }

    // Jika worker belum mengambil job dalam batas waktu polling, fallback ke V1
    return await _scanEyeSync(imagePath, onProgress: onProgress);
  }

  Future<AnemiaScanResultModel> _scanEyeSync(
    String imagePath, {
    AsyncJobProgressCallback? onProgress,
  }) async {
    onProgress?.call(40, 'Menghubungi layanan DL Anemia MobileNetV2 untuk ekstraksi ROI...');
    final multipartImage = await createMultipartFileFromPath(imagePath);
    final formData = FormData.fromMap({
      'image': multipartImage,
    });

    onProgress?.call(75, 'Menganalisis tingkat kepucatan konjungtiva mata...');
    final response = await _dio.post(
      '/anemia-scan',
      data: formData,
      options: Options(
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        onProgress?.call(100, 'Inferensi selesai.');
        return AnemiaScanResultModel.fromJson(data);
      }
      throw Exception('Invalid response format');
    } else {
      throw Exception('Failed to scan anemia');
    }
  }
}
