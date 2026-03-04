import '../../domain/entities/consent_info.dart';

class ConsentInfoModel extends ConsentInfo {
  ConsentInfoModel({
    required super.consentText,
    required super.version,
    required super.availableFields,
  });

  factory ConsentInfoModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedFields = [];
    if (json['available_fields'] is Map) {
      parsedFields = (json['available_fields'] as Map).keys.cast<String>().toList();
    } else if (json['available_fields'] is List) {
      parsedFields = List<String>.from(json['available_fields'] as List? ?? []);
    }

    return ConsentInfoModel(
      consentText: json['consent_text'] as String? ?? 'Tidak ada data',
      version: (json['consent_version'] ?? json['version']) as String? ?? '1.0',
      availableFields: parsedFields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consent_text': consentText,
      'version': version,
      'available_fields': availableFields,
    };
  }

  ConsentInfo toEntity() {
    return ConsentInfo(
      consentText: consentText,
      version: version,
      availableFields: availableFields,
    );
  }

  static ConsentInfoModel fromEntity(ConsentInfo entity) {
    return ConsentInfoModel(
      consentText: entity.consentText,
      version: entity.version,
      availableFields: entity.availableFields,
    );
  }
}
