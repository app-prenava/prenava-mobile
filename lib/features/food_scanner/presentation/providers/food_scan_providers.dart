import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/food_scan_remote_datasource.dart';
import '../../data/models/food_scan_result_model.dart';

final foodScanDatasourceProvider = Provider<FoodScanRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return FoodScanRemoteDatasource(dio);
});

class FoodScanState {
  final bool isScanning;
  final FoodScanApiResponse? result;
  final String? error;
  final String? selectedImagePath;
  final bool showBoundingBoxes;

  const FoodScanState({
    this.isScanning = false,
    this.result,
    this.error,
    this.selectedImagePath,
    this.showBoundingBoxes = true,
  });

  const FoodScanState.initial()
      : isScanning = false,
        result = null,
        error = null,
        selectedImagePath = null,
        showBoundingBoxes = true;

  FoodScanState copyWith({
    bool? isScanning,
    FoodScanApiResponse? result,
    bool clearResult = false,
    String? error,
    bool clearError = false,
    String? selectedImagePath,
    bool clearImage = false,
    bool? showBoundingBoxes,
  }) {
    return FoodScanState(
      isScanning: isScanning ?? this.isScanning,
      result: clearResult ? null : (result ?? this.result),
      error: clearError ? null : (error ?? this.error),
      selectedImagePath: clearImage ? null : (selectedImagePath ?? this.selectedImagePath),
      showBoundingBoxes: showBoundingBoxes ?? this.showBoundingBoxes,
    );
  }
}

class FoodScanNotifier extends StateNotifier<FoodScanState> {
  final FoodScanRemoteDatasource _datasource;

  FoodScanNotifier(this._datasource) : super(const FoodScanState.initial());

  void setImagePath(String path) {
    state = state.copyWith(
      selectedImagePath: path,
      clearError: true,
      clearResult: true,
    );
  }

  void toggleBoundingBoxes() {
    state = state.copyWith(showBoundingBoxes: !state.showBoundingBoxes);
  }

  Future<FoodScanApiResponse?> analyzePlate() async {
    final path = state.selectedImagePath;
    if (path == null) {
      state = state.copyWith(error: 'Pilih atau ambil foto piring makan terlebih dahulu.');
      return null;
    }

    state = state.copyWith(isScanning: true, clearError: true);

    try {
      final response = await _datasource.analyzePlate(path);
      state = state.copyWith(
        isScanning: false,
        result: response,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }

  void reset() {
    state = const FoodScanState.initial();
  }
}

final foodScanNotifierProvider = StateNotifierProvider<FoodScanNotifier, FoodScanState>((ref) {
  final ds = ref.watch(foodScanDatasourceProvider);
  return FoodScanNotifier(ds);
});
