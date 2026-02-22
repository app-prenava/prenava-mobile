import '../../domain/entities/appointment.dart';
import '../../domain/entities/bidan_profile.dart';
import 'bidan_profile_model.dart';

class AppointmentModel extends Appointment {
  AppointmentModel({
    required super.id,
    required super.bidanId,
    super.locationId,
    required super.preferredDate,
    required super.preferredTime,
    super.confirmedDate,
    super.confirmedTime,
    required super.status,
    super.notes,
    super.bidanNotes,
    required super.consultationType,
    required super.consentAccepted,
    required super.consentVersion,
    required super.sharedFields,
    super.createdAt,
    super.updatedAt,
    super.bidan,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    BidanProfile? parseBidan(dynamic value) {
      if (value == null) return null;
      return BidanProfileModel.fromJson(
        value as Map<String, dynamic>,
      ).toEntity();
    }

    return AppointmentModel(
      id: json['id'] as int,
      bidanId: json['bidan_id'] as int,
      locationId: json['location_id'] as int?,
      preferredDate: DateTime.parse(json['preferred_date'] as String),
      preferredTime: json['preferred_time'] as String,
      confirmedDate: parseDateTime(json['confirmed_date']),
      confirmedTime: json['confirmed_time'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      bidanNotes: json['bidan_notes'] as String?,
      consultationType: json['consultation_type'] as String,
      consentAccepted: json['consent_accepted'] as bool? ?? false,
      consentVersion: json['consent_version'] as String? ?? '1.0',
      sharedFields: Map<String, bool>.from(
        json['shared_fields'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
      bidan: parseBidan(json['bidan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bidan_id': bidanId,
      'location_id': locationId,
      'preferred_date':
          '${preferredDate.year}-${preferredDate.month.toString().padLeft(2, '0')}-${preferredDate.day.toString().padLeft(2, '0')}',
      'preferred_time': preferredTime,
      'confirmed_date': confirmedDate?.toIso8601String(),
      'confirmed_time': confirmedTime,
      'status': status,
      'notes': notes,
      'bidan_notes': bidanNotes,
      'consultation_type': consultationType,
      'consent_accepted': consentAccepted,
      'consent_version': consentVersion,
      'shared_fields': sharedFields,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Appointment toEntity() {
    return Appointment(
      id: id,
      bidanId: bidanId,
      locationId: locationId,
      preferredDate: preferredDate,
      preferredTime: preferredTime,
      confirmedDate: confirmedDate,
      confirmedTime: confirmedTime,
      status: status,
      notes: notes,
      bidanNotes: bidanNotes,
      consultationType: consultationType,
      consentAccepted: consentAccepted,
      consentVersion: consentVersion,
      sharedFields: sharedFields,
      createdAt: createdAt,
      updatedAt: updatedAt,
      bidan: bidan,
    );
  }

  static AppointmentModel fromEntity(Appointment entity) {
    return AppointmentModel(
      id: entity.id,
      bidanId: entity.bidanId,
      locationId: entity.locationId,
      preferredDate: entity.preferredDate,
      preferredTime: entity.preferredTime,
      confirmedDate: entity.confirmedDate,
      confirmedTime: entity.confirmedTime,
      status: entity.status,
      notes: entity.notes,
      bidanNotes: entity.bidanNotes,
      consultationType: entity.consultationType,
      consentAccepted: entity.consentAccepted,
      consentVersion: entity.consentVersion,
      sharedFields: entity.sharedFields,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      bidan: entity.bidan,
    );
  }
}
