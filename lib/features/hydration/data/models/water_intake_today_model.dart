import '../../domain/entities/water_intake_today.dart';

class WaterIntakeTodayModel extends WaterIntakeToday {
  WaterIntakeTodayModel({
    required super.tanggal,
    required super.tanggalFormatted,
    required super.jumlahMl,
    required super.jumlahGelas,
    required super.targetGelas,
    required super.targetTercapai,
    required super.persentase,
    required super.lastUpdatedFormatted,
  });

  factory WaterIntakeTodayModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeTodayModel(
      tanggal: json['tanggal'] as String,
      tanggalFormatted: json['tanggal_formatted'] as String,
      jumlahMl: json['jumlah_ml'] as int,
      jumlahGelas: json['jumlah_gelas'] as int,
      targetGelas: json['target_gelas'] as int,
      targetTercapai: json['target_tercapai'] as bool,
      persentase: json['persentase'] as int,
      lastUpdatedFormatted: json['last_updated_formatted'] as String,
    );
  }
}

