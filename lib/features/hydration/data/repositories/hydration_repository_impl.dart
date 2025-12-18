import '../../domain/repositories/hydration_repository.dart';
import '../../domain/entities/water_intake_response.dart';
import '../../domain/entities/water_intake_store_response.dart';
import '../datasources/hydration_remote_datasource.dart';

class HydrationRepositoryImpl implements HydrationRepository {
  final HydrationRemoteDatasource _datasource;

  HydrationRepositoryImpl(this._datasource);

  @override
  Future<WaterIntakeResponse> getWaterIntake() async {
    final model = await _datasource.getWaterIntake();
    return model;
  }

  @override
  Future<WaterIntakeStoreResponse> addWaterIntake({int jumlahMl = 250}) async {
    final model = await _datasource.addWaterIntake(jumlahMl: jumlahMl);
    return model;
  }
}

