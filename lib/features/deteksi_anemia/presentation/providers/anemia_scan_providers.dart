import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/health_history_image_store.dart';
import '../../data/datasources/anemia_scan_remote_datasource.dart';
import '../../data/repositories/anemia_scan_repository_impl.dart';
import '../../domain/entities/anemia_scan_result.dart';
import '../../domain/repositories/anemia_scan_repository.dart';

final anemiaScanDatasourceProvider = Provider<AnemiaScanRemoteDatasource>((
  ref,
) {
  final dio = ref.watch(appDioProvider);
  return AnemiaScanRemoteDatasource(dio);
});

final anemiaScanRepositoryProvider = Provider<AnemiaScanRepository>((ref) {
  final datasource = ref.watch(anemiaScanDatasourceProvider);
  return AnemiaScanRepositoryImpl(datasource);
});

final healthHistoryImageStoreProvider = Provider<HealthHistoryImageStore>((
  ref,
) {
  return HealthHistoryImageStore();
});

class AnemiaScanState {
  final bool isScanning;
  final AnemiaScanResult? result;
  final String? error;
  final String? selectedImagePath;
  final int progressPercentage;
  final String progressMessage;

  const AnemiaScanState({
    this.isScanning = false,
    this.result,
    this.error,
    this.selectedImagePath,
    this.progressPercentage = 0,
    this.progressMessage = '',
  });

  const AnemiaScanState.initial()
    : isScanning = false,
      result = null,
      error = null,
      selectedImagePath = null,
      progressPercentage = 0,
      progressMessage = '';

  AnemiaScanState copyWith({
    bool? isScanning,
    AnemiaScanResult? result,
    bool clearResult = false,
    String? error,
    bool clearError = false,
    String? selectedImagePath,
    bool clearImage = false,
    int? progressPercentage,
    String? progressMessage,
  }) {
    return AnemiaScanState(
      isScanning: isScanning ?? this.isScanning,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
      selectedImagePath: clearImage
          ? null
          : (selectedImagePath ?? this.selectedImagePath),
      progressPercentage: progressPercentage ?? this.progressPercentage,
      progressMessage: progressMessage ?? this.progressMessage,
    );
  }
}

class AnemiaScanNotifier extends Notifier<AnemiaScanState> {
  @override
  AnemiaScanState build() => const AnemiaScanState.initial();

  void setImagePath(String path) {
    state = state.copyWith(
      selectedImagePath: path,
      clearError: true,
      clearResult: true,
      progressPercentage: 0,
      progressMessage: '',
    );
  }

  Future<void> scanEye() async {
    if (state.selectedImagePath == null) return;

    state = state.copyWith(
      isScanning: true,
      clearError: true,
      clearResult: true,
      progressPercentage: 15,
      progressMessage: 'Citra diterima dan dijadwalkan ke antrean Redis AI...',
    );

    try {
      final datasource = ref.read(anemiaScanDatasourceProvider);
      final model = await datasource.scanEye(
        state.selectedImagePath!,
        onProgress: (pct, msg) {
          state = state.copyWith(
            progressPercentage: pct,
            progressMessage: msg,
          );
        },
      );
      final result = model.toEntity();
      final historyId = result.historyId;
      if (historyId != null) {
        final imageStore = ref.read(healthHistoryImageStoreProvider);
        final localPath = await imageStore.saveImageToAppDir(
          state.selectedImagePath!,
        );
        await imageStore.saveHistoryImagePath(historyId, localPath);
      }
      state = state.copyWith(
        isScanning: false,
        result: result,
        progressPercentage: 100,
        progressMessage: 'Inferensi selesai.',
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        progressPercentage: 0,
        progressMessage: '',
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const AnemiaScanState.initial();
  }
}

final anemiaScanNotifierProvider =
    NotifierProvider<AnemiaScanNotifier, AnemiaScanState>(
      AnemiaScanNotifier.new,
    );
