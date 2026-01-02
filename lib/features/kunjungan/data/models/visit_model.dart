import '../../domain/entities/visit.dart';
import '../../domain/entities/visit_answer.dart';

class VisitModel extends Visit {
  VisitModel({
    super.id,
    super.userId,
    required super.tanggalKunjungan,
    required super.pertanyaan,
    super.catatanBidan,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    final pertanyaanMap = <String, VisitAnswer>{};

    if (json['pertanyaan'] is List) {
      final pertanyaanList = json['pertanyaan'] as List;
      for (var item in pertanyaanList) {
        if (item is Map<String, dynamic>) {
          final id = item['id'] as String?;
          final pertanyaan = item['pertanyaan'] as String?;
          final jawaban = item['jawaban'];

          if (id != null && pertanyaan != null) {
            bool? jawabanBool;
            if (jawaban == null) {
              jawabanBool = null;
            } else if (jawaban is bool) {
              jawabanBool = jawaban;
            } else if (jawaban is int) {
              jawabanBool = jawaban == 1;
            } else if (jawaban is String) {
              jawabanBool = jawaban.toLowerCase() == 'true' || jawaban == '1';
            }

            pertanyaanMap[id] = VisitAnswer(
              jawaban: jawabanBool,
              label: pertanyaan,
            );
          }
        }
      }
    } else {
      final questionConfig = {
        'q1_demam': 'Demam lebih dari 2 hari',
        'q2_pusing': 'Pusing/sakit kepala berat',
        'q3_sulit_tidur': 'Sulit tidur/cemas berlebih',
        'q4_risiko_tb': 'Risiko TB batuk lebih dari 2 minggu atau kontak serumah dengan penderita TB',
        'q5_gerakan_bayi': 'Gerakan bayi Tidak ada atau Kurang dari 10x dalam 12 jam setelah minggu ke-24',
        'q6_nyeri_perut': 'Nyeri perut hebat',
        'q7_cairan_jalan_lahir': 'Keluar cairan dari jalan lahir sangat banyak atau berbau',
        'q8_sakit_kencing': 'Sakit saat kencing Atau keluar keputihan atau gatal di daerah kemaluan',
        'q9_diare': 'Diare berulang',
      };

      questionConfig.forEach((key, label) {
        final answerValue = json[key];
        bool? jawabanBool;

        if (answerValue == null) {
          jawabanBool = null;
        } else if (answerValue is int) {
          jawabanBool = answerValue == 1;
        } else if (answerValue is bool) {
          jawabanBool = answerValue;
        } else if (answerValue is String) {
          jawabanBool = answerValue.toLowerCase() == 'true' || answerValue == '1';
        }

        pertanyaanMap[key] = VisitAnswer(
          jawaban: jawabanBool,
          label: label,
        );
      });
    }

    DateTime? createdAt;
    DateTime? updatedAt;
    if (json['created_at'] != null) {
      createdAt = DateTime.parse(json['created_at'] as String);
    }
    if (json['updated_at'] != null) {
      updatedAt = DateTime.parse(json['updated_at'] as String);
    }

    return VisitModel(
      id: json['catatan_id'] ?? json['id'] as int?,
      userId: json['user_id'] as int?,
      tanggalKunjungan: json['tanggal_kunjungan'] != null
          ? DateTime.parse(json['tanggal_kunjungan'] as String)
          : DateTime.now(),
      pertanyaan: pertanyaanMap,
      catatanBidan: json['catatan_bidan'] as String? ?? json['hasil_kunjungan'] as String?,
      status: json['status_kunjungan'] as String? ?? json['status'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    final pertanyaanJson = <String, dynamic>{};
    pertanyaan.forEach((key, answer) {
      pertanyaanJson[key] = answer.jawaban == true ? 1 : (answer.jawaban == false ? 0 : null);
    });

    return {
      if (id != null) 'catatan_id': id,
      if (userId != null) 'user_id': userId,
      'tanggal_kunjungan': tanggalKunjungan.toIso8601String(),
      ...pertanyaanJson,
      if (catatanBidan != null) 'catatan_bidan': catatanBidan,
      if (catatanBidan != null) 'hasil_kunjungan': catatanBidan,
      if (status != null) 'status_kunjungan': status,
    };
  }

  Visit toEntity() {
    return Visit(
      id: id,
      userId: userId,
      tanggalKunjungan: tanggalKunjungan,
      pertanyaan: pertanyaan,
      catatanBidan: catatanBidan,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static VisitModel fromEntity(Visit visit) {
    return VisitModel(
      id: visit.id,
      userId: visit.userId,
      tanggalKunjungan: visit.tanggalKunjungan,
      pertanyaan: visit.pertanyaan,
      catatanBidan: visit.catatanBidan,
      status: visit.status,
      createdAt: visit.createdAt,
      updatedAt: visit.updatedAt,
    );
  }
}
