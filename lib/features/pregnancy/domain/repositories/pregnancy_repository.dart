import '../entities/pregnancy.dart';

abstract class PregnancyRepository {
  /// Calculate HPL without saving to database
  Future<Pregnancy> calculatePregnancy({required String hpht});

  /// Get my pregnancy data
  Future<Pregnancy?> getMyPregnancy();

  /// Save pregnancy data
  Future<Pregnancy> savePregnancy({
    required String hpht,
    String? babyName,
    String? babyGender,
  });

  /// Update pregnancy data
  Future<Pregnancy> updatePregnancy({
    required int id,
    required String hpht,
    String? babyName,
    String? babyGender,
  });

  /// Update health status by bidan
  Future<Pregnancy> updateHealthStatus({
    required int id,
    required bool isHighRisk,
    required bool hasDiabetes,
    required bool hasHypertension,
    required bool hasAnemia,
    required bool needsSpecialCare,
    required String notes,
  });
}
