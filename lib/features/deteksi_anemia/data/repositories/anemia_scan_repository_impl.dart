import '../../domain/entities/anemia_scan_result.dart';
import '../../domain/repositories/anemia_scan_repository.dart';
import '../datasources/anemia_scan_remote_datasource.dart';

class AnemiaScanRepositoryImpl implements AnemiaScanRepository {
  final AnemiaScanRemoteDatasource remoteDatasource;

  AnemiaScanRepositoryImpl(this.remoteDatasource);

  @override
  Future<AnemiaScanResult> scanEye(String imagePath) async {
    final model = await remoteDatasource.scanEye(imagePath);
    if (model.error != null && model.error!.isNotEmpty) {
      throw Exception(model.error);
    }
    return model;
  }
}
