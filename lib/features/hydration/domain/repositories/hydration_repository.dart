import '../entities/water_intake_response.dart';
import '../entities/water_intake_store_response.dart';

abstract class HydrationRepository {
  Future<WaterIntakeResponse> getWaterIntake();
  Future<WaterIntakeStoreResponse> addWaterIntake({int jumlahMl = 250});
}

