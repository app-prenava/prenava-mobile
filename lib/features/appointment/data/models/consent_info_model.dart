import '../../domain/entities/consent_info.dart';

class ConsentInfoModel extends ConsentInfo {
  ConsentInfoModel({
    required super.consentText,
    required super.version,
    required super.availableFields,
  });

  factory ConsentInfoModel.fromJson(Map<String, dynamic> json) {
    return ConsentInfoModel(
      consentText: json['consent_text'] as String? ?? '',
      version: json['version'] as String? ?? '1.0',
      availableFields: List<String>.from(
        json['available_fields'] as List? ?? [],
      ),
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
