import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/health_history_remote_datasource.dart';
import '../../data/repositories/health_history_repository_impl.dart';
import '../../domain/entities/health_history.dart';
import '../../domain/repositories/health_history_repository.dart';

final healthHistoryDatasourceProvider = Provider<HealthHistoryRemoteDatasource>((ref) {
  final dio = ref.watch(appDioProvider);
  return HealthHistoryRemoteDatasource(dio);
});

final healthHistoryRepositoryProvider = Provider<HealthHistoryRepository>((ref) {
  final datasource = ref.watch(healthHistoryDatasourceProvider);
  return HealthHistoryRepositoryImpl(datasource);
});

class HealthHistoryState {
  final bool isLoading;
  final List<HealthHistory> history;
  final String? error;

  const HealthHistoryState({
    this.isLoading = false,
    this.history = const [],
    this.error,
  });

  HealthHistoryState copyWith({
    bool? isLoading,
    List<HealthHistory>? history,
    String? error,
  }) {
    return HealthHistoryState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      error: error,
    );
  }
}

class HealthHistoryNotifier extends Notifier<HealthHistoryState> {
  @override
  HealthHistoryState build() {
    return const HealthHistoryState();
  }

  Future<void> fetchHistory() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(healthHistoryRepositoryProvider);
      final history = await repository.getHistory();
      state = state.copyWith(isLoading: false, history: history);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteHistory(int id) async {
    try {
      final repository = ref.read(healthHistoryRepositoryProvider);
      await repository.deleteHistory(id);
      state = state.copyWith(
        history: state.history.where((e) => e.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final healthHistoryNotifierProvider =
    NotifierProvider<HealthHistoryNotifier, HealthHistoryState>(HealthHistoryNotifier.new);
