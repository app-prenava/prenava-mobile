import '../entities/anemia_scan_result.dart';

abstract class AnemiaScanRepository {
  Future<AnemiaScanResult> scanEye(String imagePath);
}
