import 'visit_answer.dart';

class Visit {
  final int? id;
  final int? userId;
  final DateTime tanggalKunjungan;
  final Map<String, VisitAnswer> pertanyaan;
  final String? catatanBidan;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Visit({
    this.id,
    this.userId,
    required this.tanggalKunjungan,
    required this.pertanyaan,
    this.catatanBidan,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Helper methods
  bool get hasAnswers => pertanyaan.isNotEmpty;
  int get answeredCount => pertanyaan.values.where((a) => a.jawaban == true).length;
  int get totalQuestions => pertanyaan.length;

  Visit copyWith({
    int? id,
    int? userId,
    DateTime? tanggalKunjungan,
    Map<String, VisitAnswer>? pertanyaan,
    String? catatanBidan,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Visit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tanggalKunjungan: tanggalKunjungan ?? this.tanggalKunjungan,
      pertanyaan: pertanyaan ?? this.pertanyaan,
      catatanBidan: catatanBidan ?? this.catatanBidan,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
