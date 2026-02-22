import '../entities/appointment.dart';
import '../entities/bidan_profile.dart';
import '../entities/consent_info.dart';
import '../entities/consultation_type.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<Appointment> getAppointmentById(int id);
  Future<List<BidanProfile>> getBidanProfiles();
  Future<BidanProfile> getBidanProfileById(int id);
  Future<ConsentInfo> getConsentInfo();
  Future<List<ConsultationType>> getConsultationTypes();
  Future<Appointment> createAppointment(AppointmentRequest request);
  Future<bool> cancelAppointment(int id);
}

class AppointmentRequest {
  final int bidanId;
  final int? locationId;
  final DateTime preferredDate;
  final String preferredTime;
  final String consultationType;
  final String? notes;
  final bool consentAccepted;
  final String consentVersion;
  final Map<String, bool> sharedFields;

  AppointmentRequest({
    required this.bidanId,
    this.locationId,
    required this.preferredDate,
    required this.preferredTime,
    required this.consultationType,
    this.notes,
    required this.consentAccepted,
    required this.consentVersion,
    required this.sharedFields,
  });

  Map<String, dynamic> toJson() {
    return {
      'bidan_id': bidanId,
      'location_id': locationId,
      'preferred_date':
          '${preferredDate.year}-${preferredDate.month.toString().padLeft(2, '0')}-${preferredDate.day.toString().padLeft(2, '0')}',
      'preferred_time': preferredTime,
      'consultation_type': consultationType,
      'notes': notes,
      'consent_accepted': consentAccepted,
      'consent_version': consentVersion,
      'shared_fields': sharedFields,
    };
  }
}
