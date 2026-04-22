import '../../domain/entities/health_history.dart';

class HealthHistoryModel extends HealthHistory {
  const HealthHistoryModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.result,
    super.imagePath,
    required super.createdAt,
  });

  factory HealthHistoryModel.fromJson(Map<String, dynamic> json) {
    return HealthHistoryModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      result: json['result'],
      imagePath: json['image_path'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'result': result,
      'image_path': imagePath,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
