import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/appointment_remote_datasource.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/bidan_profile.dart';
import '../../domain/entities/consent_info.dart';
import '../../domain/entities/consultation_type.dart';
import '../../domain/repositories/appointment_repository.dart';

final appointmentDatasourceProvider = Provider<AppointmentRemoteDatasource>((
  ref,
) {
  final dio = ref.watch(appDioProvider);
  return AppointmentRemoteDatasource(dio);
});

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  final datasource = ref.watch(appointmentDatasourceProvider);
  return AppointmentRepositoryImpl(datasource);
});

class AppointmentState {
  final bool isLoading;
  final bool isCreating;
  final bool isPolling;
  final List<Appointment> appointments;
  final Appointment? selectedAppointment;
  final List<BidanProfile> bidans;
  final BidanProfile? selectedBidan;
  final ConsentInfo? consentInfo;
  final List<ConsultationType> consultationTypes;
  final String? error;
  final String? successMessage;

  const AppointmentState({
    this.isLoading = false,
    this.isCreating = false,
    this.isPolling = false,
    this.appointments = const [],
    this.selectedAppointment,
    this.bidans = const [],
    this.selectedBidan,
    this.consentInfo,
    this.consultationTypes = const [],
    this.error,
    this.successMessage,
  });

  const AppointmentState.initial()
    : isLoading = false,
      isCreating = false,
      isPolling = false,
      appointments = const [],
      selectedAppointment = null,
      bidans = const [],
      selectedBidan = null,
      consentInfo = null,
      consultationTypes = const [],
      error = null,
      successMessage = null;

  AppointmentState copyWith({
    bool? isLoading,
    bool? isCreating,
    bool? isPolling,
    List<Appointment>? appointments,
    Appointment? selectedAppointment,
    List<BidanProfile>? bidans,
    BidanProfile? selectedBidan,
    ConsentInfo? consentInfo,
    List<ConsultationType>? consultationTypes,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return AppointmentState(
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isPolling: isPolling ?? this.isPolling,
      appointments: appointments ?? this.appointments,
      selectedAppointment: selectedAppointment ?? this.selectedAppointment,
      bidans: bidans ?? this.bidans,
      selectedBidan: selectedBidan ?? this.selectedBidan,
      consentInfo: consentInfo ?? this.consentInfo,
      consultationTypes: consultationTypes ?? this.consultationTypes,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  List<Appointment> get filteredAppointments => appointments
      .where((appointment) => appointment.status != 'cancelled')
      .toList();

  List<Appointment> get pendingAppointments =>
      filteredAppointments.where((a) => a.status == 'requested').toList();

  List<Appointment> get acceptedAppointments =>
      filteredAppointments.where((a) => a.status == 'accepted').toList();

  List<Appointment> get completedAppointments =>
      filteredAppointments.where((a) => a.status == 'completed').toList();

  List<Appointment> get cancelledAppointments =>
      appointments.where((a) => a.status == 'cancelled').toList();

  List<Appointment> get rejectedAppointments =>
      filteredAppointments.where((a) => a.status == 'rejected').toList();
}

class AppointmentNotifier extends Notifier<AppointmentState> {
  @override
  AppointmentState build() {
    Future.microtask(() => loadInitialData());
    return const AppointmentState.initial();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadAppointments(),
      loadBidanList(),
      loadConsultationTypes(),
    ]);
  }

  Future<void> loadAppointments() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final appointments = await repository.getAppointments();
      appointments.sort((a, b) => b.preferredDate.compareTo(a.preferredDate));

      state = state.copyWith(isLoading: false, appointments: appointments);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadAppointmentDetail(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final appointment = await repository.getAppointmentById(id);

      state = state.copyWith(
        isLoading: false,
        selectedAppointment: appointment,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> loadBidanList() async {
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final bidans = await repository.getBidanProfiles();

      state = state.copyWith(bidans: bidans);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> loadBidanProfile(int id) async {
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final bidan = await repository.getBidanProfileById(id);

      state = state.copyWith(selectedBidan: bidan);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> loadConsentInfo() async {
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final consentInfo = await repository.getConsentInfo();

      state = state.copyWith(consentInfo: consentInfo);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> loadConsultationTypes() async {
    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final consultationTypes = await repository.getConsultationTypes();

      state = state.copyWith(consultationTypes: consultationTypes);
    } catch (e) {
      state = state.copyWith(error: e.toString().replaceAll('Exception: ', ''));
    }
  }

  void selectBidan(BidanProfile bidan) {
    state = state.copyWith(selectedBidan: bidan);
  }

  void clearSelectedBidan() {
    state = state.copyWith(selectedBidan: null);
  }

  Future<bool> createAppointment({
    required int bidanId,
    int? locationId,
    required DateTime preferredDate,
    required String preferredTime,
    required String consultationType,
    String? notes,
    required bool consentAccepted,
    required String consentVersion,
    required Map<String, bool> sharedFields,
  }) async {
    state = state.copyWith(
      isCreating: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final request = AppointmentRequest(
        bidanId: bidanId,
        locationId: locationId,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        consultationType: consultationType,
        notes: notes,
        consentAccepted: consentAccepted,
        consentVersion: consentVersion,
        sharedFields: sharedFields,
      );

      await repository.createAppointment(request);

      await loadAppointments();
      clearSelectedBidan();

      state = state.copyWith(
        isCreating: false,
        successMessage: 'Janji temu berhasil dibuat',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> cancelAppointment(int id) async {
    state = state.copyWith(
      isCreating: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final success = await repository.cancelAppointment(id);

      if (success) {
        await loadAppointments();

        state = state.copyWith(
          isCreating: false,
          successMessage: 'Janji temu berhasil dibatalkan',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void startPolling() {
    if (state.isPolling) return;
    state = state.copyWith(isPolling: true);
  }

  void stopPolling() {
    state = state.copyWith(isPolling: false);
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final appointmentNotifierProvider =
    NotifierProvider<AppointmentNotifier, AppointmentState>(
      AppointmentNotifier.new,
    );
