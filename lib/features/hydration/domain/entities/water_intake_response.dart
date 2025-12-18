import 'water_intake_today.dart';
import 'water_intake_history.dart';
import 'water_intake_stats.dart';

class WaterIntakeResponse {
  final String status;
  final String? message;
  final String currentTime;
  final WaterIntakeToday today;
  final List<WaterIntakeHistory> history7Hari;
  final WaterIntakeStats statistik;

  WaterIntakeResponse({
    required this.status,
    this.message,
    required this.currentTime,
    required this.today,
    required this.history7Hari,
    required this.statistik,
  });
}

