import '../../domain/entities/created_by.dart';

class CreatedByModel extends CreatedBy {
  CreatedByModel({
    required super.id,
    required super.name,
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

