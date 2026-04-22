import 'package:equatable/equatable.dart';

class HealthHistory extends Equatable {
  final int id;
  final int userId;
  final String type;
  final Map<String, dynamic> result;
  final String? imagePath;
  final DateTime createdAt;

  const HealthHistory({
    required this.id,
    required this.userId,
    required this.type,
    required this.result,
    this.imagePath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, type, result, imagePath, createdAt];
}
