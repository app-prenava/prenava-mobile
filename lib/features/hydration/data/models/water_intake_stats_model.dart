import '../../domain/entities/water_intake_stats.dart';

class WaterIntakeStatsModel extends WaterIntakeStats {
  WaterIntakeStatsModel({
    required super.rataRataGelas7Hari,
    required super.totalMl7Hari,
  });

  factory WaterIntakeStatsModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeStatsModel(
      rataRataGelas7Hari: (json['rata_rata_gelas_7_hari'] as num).toDouble(),
      totalMl7Hari: json['total_ml_7_hari'] as int,
    );
  }
}

