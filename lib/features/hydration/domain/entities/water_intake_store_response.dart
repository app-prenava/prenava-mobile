class WaterIntakeStoreResponse {
  final String status;
  final String message;
  final Map<String, dynamic> data;
  final String currentTime;

  WaterIntakeStoreResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.currentTime,
  });
}

