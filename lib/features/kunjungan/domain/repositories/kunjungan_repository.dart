import '../entities/visit.dart';

abstract class KunjunganRepository {
  // Get all visits
  Future<List<Visit>> getVisits();

  // Get visit detail by ID
  Future<Visit> getVisitById(int id);

  // Create new visit
  Future<Visit> createVisit({
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  });

  // Update existing visit
  Future<Visit> updateVisit({
    required int id,
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  });

  // Delete visit
  Future<void> deleteVisit(int id);
}
