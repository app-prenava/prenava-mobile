import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/depression_scan_remote_datasource.dart';
import '../../data/repositories/depression_scan_repository_impl.dart';
import '../../domain/entities/depression_scan_result.dart';
import '../../domain/repositories/depression_scan_repository.dart';

final depressionScanDatasourceProvider =
    Provider<DepressionScanRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return DepressionScanRemoteDatasource(dio);
});

final depressionScanRepositoryProvider =
    Provider<DepressionScanRepository>((ref) {
  final datasource = ref.watch(depressionScanDatasourceProvider);
  return DepressionScanRepositoryImpl(datasource);
});

class DepressionScanState {
  final bool isScanning;
  final DepressionScanResult? result;
  final String? error;
  final String? selectedImagePath;

  const DepressionScanState({
    this.isScanning = false,
    this.result,
    this.error,
    this.selectedImagePath,
  });

  const DepressionScanState.initial()
      : isScanning = false,
        result = null,
        error = null,
        selectedImagePath = null;

  DepressionScanState copyWith({
    bool? isScanning,
    DepressionScanResult? result,
    bool clearResult = false,
    String? error,
    bool clearError = false,
    String? selectedImagePath,
    bool clearImage = false,
  }) {
    return DepressionScanState(
      isScanning: isScanning ?? this.isScanning,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
      selectedImagePath:
          clearImage ? null : (selectedImagePath ?? this.selectedImagePath),
    );
  }
}

class DepressionScanNotifier extends Notifier<DepressionScanState> {
  @override
  DepressionScanState build() => const DepressionScanState.initial();

  void setImagePath(String path) {
    state = state.copyWith(selectedImagePath: path, clearError: true, clearResult: true);
  }

  Future<void> scanFace() async {
    if (state.selectedImagePath == null) return;

    state = state.copyWith(isScanning: true, clearError: true, clearResult: true);

    try {
      final repository = ref.read(depressionScanRepositoryProvider);
      final result = await repository.scanFace(state.selectedImagePath!);
      state = state.copyWith(isScanning: false, result: result);
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void reset() {
    state = const DepressionScanState.initial();
  }
}

final depressionScanNotifierProvider =
    NotifierProvider<DepressionScanNotifier, DepressionScanState>(
  DepressionScanNotifier.new,
);
