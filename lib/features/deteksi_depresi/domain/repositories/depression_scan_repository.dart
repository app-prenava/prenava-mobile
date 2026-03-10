import '../../domain/entities/depression_scan_result.dart';

abstract class DepressionScanRepository {
  Future<DepressionScanResult> scanFace(String imagePath);
}
