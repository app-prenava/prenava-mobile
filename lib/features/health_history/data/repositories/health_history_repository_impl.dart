import '../../domain/entities/health_history.dart';
import '../../domain/repositories/health_history_repository.dart';
import '../datasources/health_history_remote_datasource.dart';

class HealthHistoryRepositoryImpl implements HealthHistoryRepository {
  final HealthHistoryRemoteDatasource remoteDatasource;

  HealthHistoryRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<HealthHistory>> getHistory() async {
    return await remoteDatasource.getHistory();
  }

  @override
  Future<void> deleteHistory(int id) async {
    await remoteDatasource.deleteHistory(id);
  }
}
