import 'bidan_profile.dart';

class Appointment {
  final int id;
  final int bidanId;
  final int? locationId;
  final DateTime preferredDate;
  final String preferredTime;
  final DateTime? confirmedDate;
  final String? confirmedTime;
  final String status;
  final String? notes;
  final String? bidanNotes;
  final String consultationType;
  final bool consentAccepted;
  final String consentVersion;
  final Map<String, bool> sharedFields;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BidanProfile? bidan;

  Appointment({
    required this.id,
    required this.bidanId,
    this.locationId,
    required this.preferredDate,
    required this.preferredTime,
    this.confirmedDate,
    this.confirmedTime,
    required this.status,
    this.notes,
    this.bidanNotes,
    required this.consultationType,
    required this.consentAccepted,
    required this.consentVersion,
    required this.sharedFields,
    this.createdAt,
    this.updatedAt,
    this.bidan,
  });

  Appointment copyWith({
    int? id,
    int? bidanId,
    int? locationId,
    DateTime? preferredDate,
    String? preferredTime,
    DateTime? confirmedDate,
    String? confirmedTime,
    String? status,
    String? notes,
    String? bidanNotes,
    String? consultationType,
    bool? consentAccepted,
    String? consentVersion,
    Map<String, bool>? sharedFields,
    DateTime? createdAt,
    DateTime? updatedAt,
    BidanProfile? bidan,
  }) {
    return Appointment(
      id: id ?? this.id,
      bidanId: bidanId ?? this.bidanId,
      locationId: locationId ?? this.locationId,
      preferredDate: preferredDate ?? this.preferredDate,
      preferredTime: preferredTime ?? this.preferredTime,
      confirmedDate: confirmedDate ?? this.confirmedDate,
      confirmedTime: confirmedTime ?? this.confirmedTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      bidanNotes: bidanNotes ?? this.bidanNotes,
      consultationType: consultationType ?? this.consultationType,
      consentAccepted: consentAccepted ?? this.consentAccepted,
      consentVersion: consentVersion ?? this.consentVersion,
      sharedFields: sharedFields ?? this.sharedFields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bidan: bidan ?? this.bidan,
    );
  }

  bool get isRequested => status == 'requested';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get canCancel => isRequested;
}
