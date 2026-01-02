import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/kunjungan_remote_datasource.dart';
import '../../data/repositories/kunjungan_repository_impl.dart';
import '../../domain/entities/visit.dart';
import '../../domain/repositories/kunjungan_repository.dart';

const defaultQuestions = {
  'q1_demam': 'Demam lebih dari 2 hari',
  'q2_pusing': 'Pusing/sakit kepala berat',
  'q3_sulit_tidur': 'Sulit tidur/cemas berlebih',
  'q4_risiko_tb': 'Risiko TB batuk lebih dari 2 minggu atau kontak serumah dengan penderita TB',
  'q5_gerakan_bayi': 'Gerakan bayi Tidak ada atau Kurang dari 10x dalam 12 jam setelah minggu ke-24',
  'q6_nyeri_perut': 'Nyeri perut hebat',
  'q7_cairan_jalan_lahir': 'Keluar cairan dari jalan lahir sangat banyak atau berbau',
  'q8_sakit_kencing': 'Sakit saat kencing Atau keluar keputihan atau gatal di daerah kemaluan',
  'q9_diare': 'Diare berulang',
};

final kunjunganDatasourceProvider = Provider<KunjunganRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return KunjunganRemoteDatasource(dio);
});

final kunjunganRepositoryProvider = Provider<KunjunganRepository>((ref) {
  final datasource = ref.watch(kunjunganDatasourceProvider);
  return KunjunganRepositoryImpl(datasource);
});

class KunjunganState {
  final bool isLoading;
  final bool isSaving;
  final List<Visit> visits;
  final Visit? selectedVisit;
  final String? error;
  final String? successMessage;

  const KunjunganState({
    this.isLoading = false,
    this.isSaving = false,
    this.visits = const [],
    this.selectedVisit,
    this.error,
    this.successMessage,
  });

  const KunjunganState.initial()
      : isLoading = false,
        isSaving = false,
        visits = const [],
        selectedVisit = null,
        error = null,
        successMessage = null;

  KunjunganState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<Visit>? visits,
    Visit? selectedVisit,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return KunjunganState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      visits: visits ?? this.visits,
      selectedVisit: selectedVisit ?? this.selectedVisit,
      error: clearError ? null : (error ?? this.error),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }
}

class KunjunganNotifier extends Notifier<KunjunganState> {
  @override
  KunjunganState build() {
    Future.microtask(() => loadVisits());
    return const KunjunganState.initial();
  }

  Future<void> loadVisits() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(kunjunganRepositoryProvider);
      final visits = await repository.getVisits();
      visits.sort((a, b) => b.tanggalKunjungan.compareTo(a.tanggalKunjungan));

      state = state.copyWith(
        isLoading: false,
        visits: visits,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Map<String, String> getQuestionsForForm() {
    if (state.visits.isNotEmpty) {
      final latestVisit = state.visits.first;
      final questions = <String, String>{};

      latestVisit.pertanyaan.forEach((key, answer) {
        if (answer.label != null) {
          questions[key] = answer.label!;
        }
      });

      return questions.isNotEmpty ? questions : defaultQuestions;
    }

    return defaultQuestions;
  }

  Future<void> loadVisitDetail(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(kunjunganRepositoryProvider);
      final visit = await repository.getVisitById(id);

      state = state.copyWith(
        isLoading: false,
        selectedVisit: visit,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Create new visit
  Future<bool> createVisit({
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(kunjunganRepositoryProvider);
      await repository.createVisit(
        tanggalKunjungan: tanggalKunjungan,
        pertanyaan: pertanyaan,
      );

      await loadVisits();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Kunjungan berhasil ditambahkan',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> updateVisit({
    required int id,
    required DateTime tanggalKunjungan,
    required Map<String, bool?> pertanyaan,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(kunjunganRepositoryProvider);
      await repository.updateVisit(
        id: id,
        tanggalKunjungan: tanggalKunjungan,
        pertanyaan: pertanyaan,
      );

      await loadVisits();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Kunjungan berhasil diupdate',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> deleteVisit(int id) async {
    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);

    try {
      final repository = ref.read(kunjunganRepositoryProvider);
      await repository.deleteVisit(id);

      await loadVisits();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Kunjungan berhasil dihapus',
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}

final kunjunganNotifierProvider =
    NotifierProvider<KunjunganNotifier, KunjunganState>(KunjunganNotifier.new);
