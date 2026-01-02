import '../../domain/entities/visit.dart';
import '../../domain/repositories/kunjungan_repository.dart';
import '../datasources/kunjungan_remote_datasource.dart';

class KunjunganRepositoryImpl implements KunjunganRepository {
  final KunjunganRemoteDatasource _datasource;

  KunjunganRepositoryImpl(this._datasource);

  @override
  Future<List<Visit>> getVisits() async {
    final models = await _datasource.getVisits();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Visit> getVisitById(int id) async {
    final model = await _datasource.getVisitById(id);
    return model.toEntity();
  }

  @override
  Future<Visit> createVisit({
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  }) async {
    final model = await _datasource.createVisit(
      tanggalKunjungan: tanggalKunjungan,
      pertanyaan: pertanyaan,
    );

    return model.toEntity();
  }

  @override
  Future<Visit> updateVisit({
    required int id,
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  }) async {
    final model = await _datasource.updateVisit(
      id: id,
      tanggalKunjungan: tanggalKunjungan,
      pertanyaan: pertanyaan,
    );

    return model.toEntity();
  }

  @override
  Future<void> deleteVisit(int id) async {
    await _datasource.deleteVisit(id);
  }
}
