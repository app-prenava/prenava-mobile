import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/providers/feature_tracker_provider.dart';
import '../../../main/presentation/providers/main_tab_provider.dart';
import '../../data/models/screening_models.dart';

class ScreeningResultPage extends ConsumerWidget {
  final ScreeningResultModel result;
  final bool isInitial;

  const ScreeningResultPage({
    super.key,
    required this.result,
    this.isInitial = true,
  });

  Color _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFFFA6978);
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) {
      final parsed = int.tryParse('FF$cleaned', radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return const Color(0xFFFA6978);
  }

  IconData _iconForFeature(String slug) {
    switch (slug) {
      case 'tips':
        return Icons.menu_book_rounded;
      case 'local_wisdom':
        return Icons.lightbulb_outline_rounded;
      case 'kalkulator_hpl':
        return Icons.calendar_month_rounded;
      case 'komunitas':
        return Icons.groups_rounded;
      case 'anemia':
        return Icons.bloodtype_rounded;
      case 'stunting':
        return Icons.child_care_rounded;
      case 'hidrasi':
        return Icons.water_drop_rounded;
      case 'olahraga':
        return Icons.accessibility_new_rounded;
      case 'depresi':
        return Icons.psychology_alt_rounded;
      case 'appointment':
        return Icons.event_available_rounded;
      case 'kunjungan':
        return Icons.assignment_rounded;
      case 'bidan_map':
        return Icons.location_on_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  void _openFeature(BuildContext context, WidgetRef ref, RecommendedFeatureModel f) {
    final trackedFeature = appFeatureFromSlug(f.featureSlug);
    if (trackedFeature != null) {
      ref.read(featureTrackerProvider).track(trackedFeature);
    }

    if (f.route == 'tab:community') {
      mainTabIndexNotifier.value = 1;
      context.go('/home');
      return;
    }
    if (f.route == 'action:local_wisdom') {
      mainTabIndexNotifier.value = 0;
      homePendingActionNotifier.value = 'local_wisdom';
      context.go('/home');
      return;
    }
    if (f.route.startsWith('/')) {
      if (isInitial) {
        context.go('/home');
        Future.microtask(() {
          if (context.mounted) context.push(f.route);
        });
      } else {
        context.push(f.route);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = result.primaryCategory;
    final accentColor = _parseHexColor(category?.badgeColor);

    final dimensionMeta = const [
      ('literacy', 'Pemahaman Kehamilan'),
      ('nutrition', 'Gizi & Kesehatan Fisik'),
      ('mental', 'Ketenangan & Emosi'),
      ('anc', 'Kontrol & Layanan Bidan'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: !isInitial,
        title: const Text(
          'Hasil Personalisasi Bunda',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category summary card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.82),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Fokus Utama Bunda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category?.displayName ?? 'Pemantauan Kehamilan Optimal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category?.description ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.94),
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4-Dimension Readiness Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan 4 Aspek Kesiapan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...dimensionMeta.map((item) {
                      final score = result.dimensionScores[item.$1] ?? 0;
                      final needsFocus = score < 60;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.$2,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF424242),
                                  ),
                                ),
                                Text(
                                  needsFocus ? 'Perlu Fokus ($score%)' : 'Baik ($score%)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: needsFocus
                                        ? const Color(0xFFFA6978)
                                        : const Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: (score / 100).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  needsFocus
                                      ? const Color(0xFFFA6978)
                                      : const Color(0xFF43A047),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Recommended Features List
              const Text(
                'Fitur yang Kami Tonjolkan Untuk Bunda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Fitur ini juga akan muncul di baris teratas beranda Bunda.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ...result.recommendedFeatures.map((feature) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _iconForFeature(feature.featureSlug),
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      feature.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        feature.reason,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey[600],
                          height: 1.35,
                        ),
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () => _openFeature(context, ref, feature),
                      style: TextButton.styleFrom(
                        foregroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text(
                        'Buka',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () => _openFeature(context, ref, feature),
                  ),
                );
              }),
              const SizedBox(height: 12),

              // Disclaimer
              Text(
                'Catatan: Rekomendasi ini digunakan untuk personalisasi fitur aplikasi dan tidak menggantikan konsultasi langsung dengan bidan atau dokter.',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  mainTabIndexNotifier.value = 0;
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Lanjut ke Beranda',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
