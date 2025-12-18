import '../../domain/entities/water_intake_history.dart';

class WaterIntakeHistoryModel extends WaterIntakeHistory {
  WaterIntakeHistoryModel({
    required super.tanggal,
    required super.tanggalLabel,
    required super.tanggalFormatted,
    required super.jumlahMl,
    required super.jumlahGelas,
  });

  factory WaterIntakeHistoryModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeHistoryModel(
      tanggal: json['tanggal'] as String,
      tanggalLabel: json['tanggal_label'] as String,
      tanggalFormatted: json['tanggal_formatted'] as String,
      jumlahMl: json['jumlah_ml'] as int,
      jumlahGelas: json['jumlah_gelas'] as int,
    );
  }
}

