import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

class MaternalCompletenessData {
  final double percentage;
  final int count;
  final int total;
  final List<String> missingModalities;
  final String label;
  final String level;
  final String badgeColorHex;
  final String supportiveMessage;

  const MaternalCompletenessData({
    required this.percentage,
    required this.count,
    this.total = 4,
    required this.missingModalities,
    required this.label,
    required this.level,
    required this.badgeColorHex,
    required this.supportiveMessage,
  });

  factory MaternalCompletenessData.fromJson(Map<String, dynamic> json) {
    final badge = (json['badge'] as Map<String, dynamic>?) ?? {};
    final rawMissing = json['missing_modalities'];
    final List<String> missing = rawMissing is List
        ? rawMissing.map((e) => e.toString()).toList()
        : [];

    return MaternalCompletenessData(
      percentage: ((json['completeness_percentage'] ?? 0) as num).toDouble(),
      count: ((json['modalities_count'] ?? 0) as num).toInt(),
      total: ((json['total_modalities'] ?? 4) as num).toInt(),
      missingModalities: missing,
      label: badge['label']?.toString() ?? 'Pemantauan Mandiri',
      level: badge['level']?.toString() ?? 'EMPTY',
      badgeColorHex: badge['color']?.toString() ?? '#FA6978',
      supportiveMessage: json['supportive_message']?.toString() ??
          'Lengkapi pemantauan kesehatan mandiri di bawah ini agar Bidan dapat memantau kondisi Ibu secara optimal.',
    );
  }

  factory MaternalCompletenessData.initial() {
    return const MaternalCompletenessData(
      percentage: 0.0,
      count: 0,
      total: 4,
      missingModalities: [
        'Skrining Stunting Maternal',
        'Pemeriksaan Anemia Mata',
        'Asesmen Tensi & Komplikasi',
        'Pemindaian Piring Nutrisi',
      ],
      label: 'Belum Ada Data (0/4)',
      level: 'EMPTY',
      badgeColorHex: '#FA6978',
      supportiveMessage:
          'Lengkapi pemantauan kesehatan mandiri di bawah ini agar Bidan dapat memantau kondisi Ibu secara optimal.',
    );
  }
}

final maternalCompletenessProvider =
    FutureProvider.autoDispose<MaternalCompletenessData>((ref) async {
  try {
    final dio = ref.watch(appDioProvider);
    final response = await dio.get('/user/maternal-triage');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as Map<String, dynamic>?;
      if (data != null) {
        return MaternalCompletenessData.fromJson(data);
      }
    }
  } catch (e) {
    debugPrint('[MATERNAL_TRIAGE] Error fetching completeness: $e');
  }

  return MaternalCompletenessData.initial();
});
