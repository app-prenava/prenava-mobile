import '../../domain/entities/depression_scan_result.dart';
import '../../domain/repositories/depression_scan_repository.dart';
import '../datasources/depression_scan_remote_datasource.dart';

class DepressionScanRepositoryImpl implements DepressionScanRepository {
  final DepressionScanRemoteDatasource _datasource;

  DepressionScanRepositoryImpl(this._datasource);

  @override
  Future<DepressionScanResult> scanFace(String imagePath) {
    return _datasource.scanFace(imagePath);
  }
}
