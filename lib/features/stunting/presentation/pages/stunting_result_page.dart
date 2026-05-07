import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/core/theme/app_theme.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/presentation/providers/stunting_providers.dart';
import 'package:prenava_mobile/features/stunting/presentation/utils/humanized_mapper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dotted_border/dotted_border.dart';

class StuntingResultPage extends ConsumerWidget {
  final PredictionResult result;

  const StuntingResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHighRisk = result.riskLabel == 'high_risk';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hasil Analisis'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/stunting/history'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRiskCard(isHighRisk),
            const SizedBox(height: 24),
            _buildExplanationSection(result.explanation),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(stuntingRecommendationProvider.notifier).fetch(result.id);
                context.push('/stunting/recommendations', extra: result.id);
              },
              child: const Text('Lihat Rekomendasi & Rencana Makan'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard(bool isHighRisk) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(24),
        color: isHighRisk ? AppColors.warningRed : AppColors.successGreen,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        padding: EdgeInsets.zero,
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
        children: [
          Icon(
            isHighRisk ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
            size: 64,
            color: isHighRisk ? AppColors.warningRed : AppColors.successGreen,
          ),
          const SizedBox(height: 16),
          Text(
            isHighRisk ? 'Risiko Tinggi' : 'Risiko Rendah',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isHighRisk ? AppColors.warningRed : AppColors.successGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Probabilitas: ${(result.probability * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isHighRisk
                ? 'Berdasarkan data Anda, terdapat indikasi risiko stunting pada janin. Jangan khawatir, ikuti rekomendasi gizi kami untuk meminimalisir risiko.'
                : 'Berdasarkan data Anda, risiko stunting pada janin tergolong rendah. Pertahankan pola hidup sehat dan pemeriksaan rutin.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildExplanationSection(ShapExplanation? explanation) {
    if (explanation == null || explanation.topFactors.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Faktor Kontribusi Utama',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...explanation.topFactors.map((factor) {
          final label = HumanizedMapper.getLabel(factor.feature);
          final isIncreasing = factor.impact == 'increase_risk';
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    isIncreasing ? Icons.trending_up : Icons.trending_down,
                    size: 24,
                    color: isIncreasing ? AppColors.warningRed : AppColors.successGreen,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          HumanizedMapper.getRiskDescription(label, factor.value),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }
}
