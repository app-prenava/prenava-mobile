import 'package:dio/dio.dart';
import '../models/maternal_rag_model.dart';

class MaternalRagRemoteDatasource {
  final Dio _dio;

  MaternalRagRemoteDatasource(this._dio);

  /// POST /api/v1/maternal-rag/ask-text
  Future<MaternalConsultationItem> askText({
    required String query,
    int? pregnancyId,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/maternal-rag/ask-text',
        data: {
          'query': query,
          if (pregnancyId != null) 'pregnancy_id': pregnancyId,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 45),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final consultation = data['consultation'] as Map<String, dynamic>? ?? {};
        final ragResult = data['rag_result'] as Map<String, dynamic>? ?? {};
        
        // Merge into complete item
        final merged = <String, dynamic>{
          ...consultation,
          'query': query,
          'answer': ragResult['answer'] ?? consultation['ai_answer'] ?? '',
          'reference_source': ragResult['reference_source'] ?? consultation['reference_source'] ?? 'Buku KIA Kemenkes RI',
          'is_emergency': ragResult['is_emergency'] ?? consultation['is_emergency'] ?? false,
          'danger_level': ragResult['danger_level'] ?? consultation['danger_level'] ?? 'NORMAL',
          'danger_keywords': ragResult['danger_keywords'] ?? consultation['danger_keywords'] ?? [],
          'recommended_action': ragResult['recommended_action'] ?? consultation['recommended_action'],
          'provider_used': ragResult['provider_used'] ?? consultation['provider_used'] ?? 'groq',
        };

        return MaternalConsultationItem.fromJson(merged);
      }
      throw Exception('Format respon server tidak valid.');
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw Exception(msg ?? 'Gagal menghubungi Bidan AI: ${e.message}');
    }
  }

  /// POST /api/v1/maternal-rag/ask-voice
  Future<MaternalConsultationItem> askVoice({
    required MultipartFile audioFile,
    int? pregnancyId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': audioFile,
        if (pregnancyId != null) 'pregnancy_id': pregnancyId,
      });

      final response = await _dio.post(
        '/v1/maternal-rag/ask-voice',
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final consultation = data['consultation'] as Map<String, dynamic>? ?? {};
        final ragResult = data['rag_result'] as Map<String, dynamic>? ?? {};

        final merged = <String, dynamic>{
          ...consultation,
          'query': ragResult['transcribed_text'] ?? consultation['transcribed_text'] ?? 'Konsultasi Suara',
          'answer': ragResult['answer'] ?? consultation['ai_answer'] ?? '',
          'reference_source': ragResult['reference_source'] ?? consultation['reference_source'] ?? 'Buku KIA Kemenkes RI',
          'is_emergency': ragResult['is_emergency'] ?? consultation['is_emergency'] ?? false,
          'danger_level': ragResult['danger_level'] ?? consultation['danger_level'] ?? 'NORMAL',
          'danger_keywords': ragResult['danger_keywords'] ?? consultation['danger_keywords'] ?? [],
          'recommended_action': ragResult['recommended_action'] ?? consultation['recommended_action'],
          'provider_used': ragResult['provider_used'] ?? consultation['provider_used'] ?? 'groq',
        };

        return MaternalConsultationItem.fromJson(merged);
      }
      throw Exception('Format respon suara tidak valid.');
    } on DioException catch (e) {
      final msg = e.response?.data is Map ? e.response?.data['message'] : null;
      throw Exception(msg ?? 'Gagal memproses rekaman suara: ${e.message}');
    }
  }

  /// GET /api/v1/maternal-rag/history
  Future<List<MaternalConsultationItem>> getHistory() async {
    try {
      final response = await _dio.get('/v1/maternal-rag/history');
      final data = response.data;
      if (data is Map<String, dynamic> && data['history'] is List) {
        return (data['history'] as List)
            .map((item) => MaternalConsultationItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// GET /api/v1/maternal-rag/danger-catalog
  Future<List<DangerCategoryItem>> getDangerCatalog() async {
    try {
      final response = await _dio.get('/v1/maternal-rag/danger-catalog');
      final data = response.data;
      if (data is Map<String, dynamic> && data['catalog'] is List) {
        return (data['catalog'] as List)
            .map((item) => DangerCategoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
