import '../../domain/entities/pregnancy.dart';
import '../../domain/repositories/pregnancy_repository.dart';
import '../datasources/pregnancy_remote_datasource.dart';

class PregnancyRepositoryImpl implements PregnancyRepository {
  final PregnancyRemoteDatasource remoteDatasource;

  PregnancyRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Pregnancy> calculatePregnancy({required String hpht}) {
    return remoteDatasource.calculatePregnancy(hpht: hpht).then((model) => model.toEntity());
  }

  @override
  Future<Pregnancy?> getMyPregnancy() async {
    final model = await remoteDatasource.getMyPregnancy();
    return model?.toEntity();
  }

  @override
  Future<Pregnancy> savePregnancy({
    required String hpht,
    String? babyName,
    String? babyGender,
  }) {
    return remoteDatasource
        .savePregnancy(
          hpht: hpht,
          babyName: babyName,
          babyGender: babyGender,
        )
        .then((model) => model.toEntity());
  }

  @override
  Future<Pregnancy> updatePregnancy({
    required int id,
    required String hpht,
    String? babyName,
    String? babyGender,
  }) {
    return remoteDatasource
        .updatePregnancy(
          id: id,
          hpht: hpht,
          babyName: babyName,
          babyGender: babyGender,
        )
        .then((model) => model.toEntity());
  }

  @override
  Future<Pregnancy> updateHealthStatus({
    required int id,
    required bool isHighRisk,
    required bool hasDiabetes,
    required bool hasHypertension,
    required bool hasAnemia,
    required bool needsSpecialCare,
    required String notes,
  }) {
    return remoteDatasource
        .updateHealthStatus(
          id: id,
          isHighRisk: isHighRisk,
          hasDiabetes: hasDiabetes,
          hasHypertension: hasHypertension,
          hasAnemia: hasAnemia,
          needsSpecialCare: needsSpecialCare,
          notes: notes,
        )
        .then((model) => model.toEntity());
  }
}
