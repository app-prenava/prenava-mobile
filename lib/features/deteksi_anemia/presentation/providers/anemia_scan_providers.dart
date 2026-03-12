import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/anemia_scan_remote_datasource.dart';
import '../../data/repositories/anemia_scan_repository_impl.dart';
import '../../domain/entities/anemia_scan_result.dart';
import '../../domain/repositories/anemia_scan_repository.dart';

final anemiaScanDatasourceProvider =
    Provider<AnemiaScanRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return AnemiaScanRemoteDatasource(dio);
});

final anemiaScanRepositoryProvider =
    Provider<AnemiaScanRepository>((ref) {
  final datasource = ref.watch(anemiaScanDatasourceProvider);
  return AnemiaScanRepositoryImpl(datasource);
});

class AnemiaScanState {
  final bool isScanning;
  final AnemiaScanResult? result;
  final String? error;
  final String? selectedImagePath;

  const AnemiaScanState({
    this.isScanning = false,
    this.result,
    this.error,
    this.selectedImagePath,
  });

  const AnemiaScanState.initial()
      : isScanning = false,
        result = null,
        error = null,
        selectedImagePath = null;

  AnemiaScanState copyWith({
    bool? isScanning,
    AnemiaScanResult? result,
    bool clearResult = false,
    String? error,
    bool clearError = false,
    String? selectedImagePath,
    bool clearImage = false,
  }) {
    return AnemiaScanState(
      isScanning: isScanning ?? this.isScanning,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
      selectedImagePath:
          clearImage ? null : (selectedImagePath ?? this.selectedImagePath),
    );
  }
}

class AnemiaScanNotifier extends Notifier<AnemiaScanState> {
  @override
  AnemiaScanState build() => const AnemiaScanState.initial();

  void setImagePath(String path) {
    state = state.copyWith(selectedImagePath: path, clearError: true, clearResult: true);
  }

  Future<void> scanEye() async {
    if (state.selectedImagePath == null) return;

    state = state.copyWith(isScanning: true, clearError: true, clearResult: true);

    try {
      final repository = ref.read(anemiaScanRepositoryProvider);
      final result = await repository.scanEye(state.selectedImagePath!);
      state = state.copyWith(isScanning: false, result: result);
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
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
