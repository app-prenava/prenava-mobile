import 'package:dio/dio.dart';
import '../models/screening_models.dart';

class ScreeningRemoteDatasource {
  final Dio _dio;

  ScreeningRemoteDatasource(this._dio);

  Future<ScreeningQuestionsResponse> getQuestions({String version = 'v1'}) async {
    final response = await _dio.get(
      '/user/screening/questions',
      queryParameters: {'version': version},
    );
    return ScreeningQuestionsResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<ScreeningResultModel> submitScreening({
    required String version,
    required Map<int, String> answers,
  }) async {
    final payload = {
      'version': version,
      'answers': answers.entries
          .map((e) => {
                'question_id': e.key,
                'selected_value': e.value,
              })
          .toList(),
    };

    final response = await _dio.post('/user/screening/submit', data: payload);
    return ScreeningResultModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<ScreeningResultModel> getLatest() async {
    final response = await _dio.get('/user/screening/latest');
    return ScreeningResultModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<ScreeningHistoryResponse> getHistory() async {
    final response = await _dio.get('/user/screening/history');
    return ScreeningHistoryResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
