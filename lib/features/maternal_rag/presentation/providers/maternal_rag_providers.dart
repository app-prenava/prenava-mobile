import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/maternal_rag_remote_datasource.dart';
import '../../data/models/maternal_rag_model.dart';

final maternalRagDatasourceProvider = Provider<MaternalRagRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return MaternalRagRemoteDatasource(dio);
});

class MaternalRagState {
  final bool isLoading;
  final String? errorMessage;
  final List<MaternalConsultationItem> consultations;
  final List<DangerCategoryItem> dangerCatalog;
  final MaternalConsultationItem? activeEmergency;

  const MaternalRagState({
    this.isLoading = false,
    this.errorMessage,
    this.consultations = const [],
    this.dangerCatalog = const [],
    this.activeEmergency,
  });

  MaternalRagState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<MaternalConsultationItem>? consultations,
    List<DangerCategoryItem>? dangerCatalog,
    MaternalConsultationItem? activeEmergency,
    bool clearEmergency = false,
  }) {
    return MaternalRagState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      consultations: consultations ?? this.consultations,
      dangerCatalog: dangerCatalog ?? this.dangerCatalog,
      activeEmergency: clearEmergency ? null : (activeEmergency ?? this.activeEmergency),
    );
  }
}

class MaternalRagNotifier extends StateNotifier<MaternalRagState> {
  final MaternalRagRemoteDatasource _datasource;

  MaternalRagNotifier(this._datasource) : super(const MaternalRagState()) {
    init();
  }

  Future<void> init() async {
    await Future.wait([
      fetchDangerCatalog(),
      fetchHistory(),
    ]);
  }

  Future<void> fetchDangerCatalog() async {
    try {
      final catalog = await _datasource.getDangerCatalog();
      state = state.copyWith(dangerCatalog: catalog);
    } catch (_) {}
  }

  Future<void> fetchHistory() async {
    try {
      final history = await _datasource.getHistory();
      if (history.isNotEmpty) {
        state = state.copyWith(consultations: history);
      }
    } catch (_) {}
  }

  Future<void> askText(String query, {int? pregnancyId}) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _datasource.askText(
        query: query.trim(),
        pregnancyId: pregnancyId,
      );

      final updated = [result, ...state.consultations];
      state = state.copyWith(
        isLoading: false,
        consultations: updated,
        activeEmergency: result.isEmergency ? result : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> askVoice(MultipartFile file, {int? pregnancyId}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await _datasource.askVoice(
        audioFile: file,
        pregnancyId: pregnancyId,
      );

      final updated = [result, ...state.consultations];
      state = state.copyWith(
        isLoading: false,
        consultations: updated,
        activeEmergency: result.isEmergency ? result : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void dismissEmergency() {
    state = state.copyWith(clearEmergency: true);
  }
}

final maternalRagNotifierProvider =
    StateNotifierProvider<MaternalRagNotifier, MaternalRagState>((ref) {
  final datasource = ref.watch(maternalRagDatasourceProvider);
  return MaternalRagNotifier(datasource);
});
