import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/sport_recommendation.dart';

class RecommendationResultView extends StatelessWidget {
  final List<SportRecommendation> recommendations;
  final VoidCallback? onRetakeAssessment;

  const RecommendationResultView({
    super.key,
    required this.recommendations,
    this.onRetakeAssessment,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          ...recommendations
              .asMap()
              .entries
              .map((entry) => _buildRecommendationCard(context, entry.value, entry.key + 1)),
          const SizedBox(height: 16),
          _buildRetakeButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rekomendasi Untuk Anda',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Berikut gerakan olahraga yang direkomendasikan berdasarkan kondisi kesehatan Anda.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, SportRecommendation rec, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images carousel if available
          if (rec.picture1 != null || rec.picture2 != null || rec.picture3 != null)
            _buildImageSection(rec),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rank badge and activity title
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA6978),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rec.activity,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Score indicator
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFB74D), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Skor: ${(rec.score * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFB74D),
                      ),
                    ),
                  ],
                ),
                if (rec.longText != null && rec.longText!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    rec.longText!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
                if (rec.videoLink != null && rec.videoLink!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () => _launchUrl(rec.videoLink!),
                      icon: const Icon(Icons.play_circle_outline, size: 20),
                      label: const Text('Tonton Video Tutorial'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFA6978),
                        side: const BorderSide(color: Color(0xFFFA6978)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(SportRecommendation rec) {
    final images = [rec.picture1, rec.picture2, rec.picture3]
        .where((img) => img != null && img.isNotEmpty)
        .cast<String>()
        .toList();

    if (images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFF5F5F5),
                  child: const Center(
                    child: Icon(Icons.image_not_supported,
                        size: 40, color: Color(0xFFBDBDBD)),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: const Color(0xFFF5F5F5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFA6978),
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildRetakeButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onRetakeAssessment,
        icon: const Icon(Icons.refresh_rounded, size: 20),
        label: const Text('Ulangi Penilaian'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFA6978),
          side: const BorderSide(color: Color(0xFFFA6978)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
