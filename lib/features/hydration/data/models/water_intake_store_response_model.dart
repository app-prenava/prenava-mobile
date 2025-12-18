import '../../domain/entities/water_intake_store_response.dart';

class WaterIntakeStoreResponseModel extends WaterIntakeStoreResponse {
  WaterIntakeStoreResponseModel({
    required super.status,
    required super.message,
    required super.data,
    required super.currentTime,
  });

  factory WaterIntakeStoreResponseModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeStoreResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
      currentTime: json['current_time'] as String,
    );
  }
}

