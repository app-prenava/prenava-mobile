import '../../domain/entities/consultation_type.dart';

class ConsultationTypeModel extends ConsultationType {
  ConsultationTypeModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory ConsultationTypeModel.fromJson(Map<String, dynamic> json) {
    return ConsultationTypeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  ConsultationType toEntity() {
    return ConsultationType(id: id, name: name, description: description);
  }

  static ConsultationTypeModel fromEntity(ConsultationType entity) {
    return ConsultationTypeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
    );
  }
}
