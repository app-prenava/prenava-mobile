import 'dart:io';

import '../../../../core/utils/health_history_image_store.dart';
import '../../domain/entities/health_history.dart';
import '../../domain/repositories/health_history_repository.dart';
import '../models/health_history_model.dart';
import '../datasources/health_history_remote_datasource.dart';

class HealthHistoryRepositoryImpl implements HealthHistoryRepository {
  final HealthHistoryRemoteDatasource remoteDatasource;
  final HealthHistoryImageStore imageStore;

  HealthHistoryRepositoryImpl(this.remoteDatasource, this.imageStore);

  @override
  Future<List<HealthHistory>> getHistory() async {
    final history = await remoteDatasource.getHistory();
    final merged = <HealthHistory>[];

    for (final item in history) {
      final localPath = await imageStore.getHistoryImagePath(item.id);
      if (localPath != null && localPath.isNotEmpty) {
        final localFile = File(localPath);
        if (await localFile.exists()) {
          merged.add(
            HealthHistoryModel(
              id: item.id,
              userId: item.userId,
              type: item.type,
              result: item.result,
              imagePath: item.imagePath,
              localImagePath: localPath,
              createdAt: item.createdAt,
            ),
          );
          continue;
        }
      }

      merged.add(item);
    }

    return merged;
  }

  @override
  Future<void> deleteHistory(int id) async {
    await remoteDatasource.deleteHistory(id);
    await imageStore.deleteHistoryImage(id);
  }
}
