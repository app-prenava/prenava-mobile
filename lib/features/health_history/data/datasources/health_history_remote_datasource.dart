import 'package:dio/dio.dart';
import '../models/health_history_model.dart';

class HealthHistoryRemoteDatasource {
  final Dio dio;

  HealthHistoryRemoteDatasource(this.dio);

  Future<List<HealthHistoryModel>> getHistory() async {
    try {
      final response = await dio.get('/health/history');
      if (response.data['status'] == 'success') {
        final List list = response.data['data'];
        return list.map((e) => HealthHistoryModel.fromJson(e)).toList();
      }
      throw Exception(response.data['message'] ?? 'Failed to fetch history');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteHistory(int id) async {
    try {
      final response = await dio.delete('/health/history/$id');
      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to delete history');
      }
    } catch (e) {
      rethrow;
    }
  }
}
