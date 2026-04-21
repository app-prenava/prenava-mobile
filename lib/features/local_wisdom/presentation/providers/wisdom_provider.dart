import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/wisdom_item.dart';

/// Provider untuk menyimpan filter region yang dipilih
final selectedRegionProvider = StateProvider<String>((ref) => 'Semua');

class WisdomNotifier extends AsyncNotifier<List<WisdomItem>> {
  @override
  Future<List<WisdomItem>> build() async {
    return _fetchFromApi();
  }

  Future<List<WisdomItem>> _fetchFromApi() async {
    final dio = ref.read(appDioProvider);
    final response = await dio.get('/user/local-wisdom');
    
    final List data = response.data;
    return data.map((json) => WisdomItem(
      id: json['id'],
      myth: json['myth'],
      reason: json['reason'],
      region: json['region'],
      isChecked: json['is_checked'] ?? false,
    )).toList();
  }

  Future<void> toggle(int id) async {
    final current = state.value;
    if (current == null) return;

    // Optimistic UI update
    state = AsyncData(
      current.map((e) => e.id == id ? e.copyWith(isChecked: !e.isChecked) : e).toList(),
    );

    try {
      final dio = ref.read(appDioProvider);
      await dio.post('/user/local-wisdom/toggle', data: {
        'local_wisdom_id': id
      });
      // Refresh to ensure sync with server
      ref.invalidateSelf();
    } catch (e) {
      // Revert if error
      state = AsyncData(current);
    }
  }
}

final wisdomProvider =
    AsyncNotifierProvider<WisdomNotifier, List<WisdomItem>>(WisdomNotifier.new);

final wisdomCheckedCountProvider = Provider<int>((ref) {
  final items = ref.watch(wisdomProvider).value ?? [];
  return items.where((e) => e.isChecked).length;
});
