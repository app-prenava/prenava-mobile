import '../../domain/entities/appointment.dart';
import '../../domain/entities/bidan_profile.dart';
import '../../domain/entities/consent_info.dart';
import '../../domain/entities/consultation_type.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointment_remote_datasource.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDatasource _datasource;

  AppointmentRepositoryImpl(this._datasource);

  @override
  Future<List<Appointment>> getAppointments() async {
    final models = await _datasource.getAppointments();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Appointment> getAppointmentById(int id) async {
    final model = await _datasource.getAppointmentById(id);
    return model.toEntity();
  }

  @override
  Future<List<BidanProfile>> getBidanProfiles() async {
    final models = await _datasource.getBidanProfiles();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<BidanProfile> getBidanProfileById(int id) async {
    final model = await _datasource.getBidanProfileById(id);
    return model.toEntity();
  }

  @override
  Future<ConsentInfo> getConsentInfo() async {
    final model = await _datasource.getConsentInfo();
    return model.toEntity();
  }

  @override
  Future<List<ConsultationType>> getConsultationTypes() async {
    final models = await _datasource.getConsultationTypes();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Appointment> createAppointment(AppointmentRequest request) async {
    final model = await _datasource.createAppointment(request.toJson());
    return model.toEntity();
  }

  @override
  Future<bool> cancelAppointment(int id) async {
    return await _datasource.cancelAppointment(id);
  }
}
