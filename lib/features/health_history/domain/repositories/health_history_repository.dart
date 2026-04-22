import '../../domain/entities/health_history.dart';

abstract class HealthHistoryRepository {
  Future<List<HealthHistory>> getHistory();
  Future<void> deleteHistory(int id);
}
