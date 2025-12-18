import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/hydration_remote_datasource.dart';
import '../../data/repositories/hydration_repository_impl.dart';
import '../../domain/repositories/hydration_repository.dart';
import '../../domain/entities/water_intake_response.dart';

// Datasource Provider
final hydrationDatasourceProvider = Provider<HydrationRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return HydrationRemoteDatasource(dio);
});

// Repository Provider
final hydrationRepositoryProvider =
    Provider<HydrationRepository>((ref) {
  final datasource = ref.watch(hydrationDatasourceProvider);
  return HydrationRepositoryImpl(datasource);
});

// Main Provider untuk get water intake
final waterIntakeProvider =
    FutureProvider<WaterIntakeResponse>((ref) async {
  final repository = ref.watch(hydrationRepositoryProvider);
  return await repository.getWaterIntake();
});

// Notifier untuk add water intake
class WaterIntakeNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> addWaterIntake({int jumlahMl = 250}) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(hydrationRepositoryProvider);
      await repository.addWaterIntake(jumlahMl: jumlahMl);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final waterIntakeNotifierProvider =
    NotifierProvider<WaterIntakeNotifier, AsyncValue<void>>(() {
  return WaterIntakeNotifier();
});

