import '../../domain/entities/water_intake_response.dart';
import 'water_intake_today_model.dart';
import 'water_intake_history_model.dart';
import 'water_intake_stats_model.dart';

class WaterIntakeResponseModel extends WaterIntakeResponse {
  WaterIntakeResponseModel({
    required super.status,
    super.message,
    required super.currentTime,
    required super.today,
    required super.history7Hari,
    required super.statistik,
  });

  factory WaterIntakeResponseModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeResponseModel(
      status: json['status'] as String,
      message: json['message'] as String?,
      currentTime: json['current_time'] as String,
      today: WaterIntakeTodayModel.fromJson(
        json['today'] as Map<String, dynamic>,
      ),
      history7Hari: (json['history_7_hari'] as List)
          .map((e) => WaterIntakeHistoryModel.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList(),
      statistik: WaterIntakeStatsModel.fromJson(
        json['statistik'] as Map<String, dynamic>,
      ),
    );
  }
}

