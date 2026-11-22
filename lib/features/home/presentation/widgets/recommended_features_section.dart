import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../screening/data/models/screening_models.dart';

class RecommendedFeaturesSection extends StatelessWidget {
  final ScreeningResultModel screening;
  final void Function(RecommendedFeatureModel feature) onFeatureTap;

  const RecommendedFeaturesSection({
    super.key,
    required this.screening,
    required this.onFeatureTap,
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

  @override
  Widget build(BuildContext context) {
    if (!screening.hasCompletedScreening ||
        screening.recommendedFeatures.isEmpty) {
      return const SizedBox.shrink();
    }

    final category = screening.primaryCategory;
    final accentColor = _parseHexColor(category?.badgeColor);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rekomendasi Untuk Bunda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242),
                        ),
                      ),
                      if (category != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            category.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/screening/history'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFA6978),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Skrining Ulang',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 138,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: screening.recommendedFeatures.length,
              itemBuilder: (context, index) {
                final feature = screening.recommendedFeatures[index];
                return GestureDetector(
                  onTap: () => onFeatureTap(feature),
                  child: Container(
                    width: 215,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _iconForFeature(feature.featureSlug),
                                size: 18,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature.title,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            feature.reason,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey[700],
                              height: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Mulai',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: accentColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
