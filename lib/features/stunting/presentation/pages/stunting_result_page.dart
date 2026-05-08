import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/presentation/utils/humanized_mapper.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StuntingResultPage extends StatelessWidget {
  final PredictionResult result;

  const StuntingResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isHighRisk = result.riskLabel == 'high_risk';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1C1C1E), size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Color(0xFF1C1C1E)),
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
            _buildExplanationSection(context, result.explanation),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.push(
                  '/stunting-food/recommendations',
                  extra: result.id,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A7A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Lihat Rekomendasi Makanan',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(
                  color: Color(0xFF6E6E73),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard(bool isHighRisk) {
    final Color statusColor =
        isHighRisk ? const Color(0xFFFF375F) : const Color(0xFF34C759);
    final Color softStatusColor = statusColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: softStatusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHighRisk ? Icons.warning_rounded : Icons.check_circle_rounded,
              size: 40,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isHighRisk ? 'Risiko Tinggi' : 'Risiko Rendah',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Probabilitas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6E6E73),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(result.probability * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isHighRisk
                  ? 'Berdasarkan data Anda, terdapat indikasi risiko stunting pada janin. Jangan khawatir, ikuti rekomendasi gizi kami untuk meminimalisir risiko.'
                  : 'Berdasarkan data Anda, risiko stunting pada janin tergolong rendah. Pertahankan pola hidup sehat dan pemeriksaan rutin.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1C1C1E),
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0);
  }

  Widget _buildExplanationSection(BuildContext context, ShapExplanation? explanation) {
    if (explanation == null || explanation.topFactors.isEmpty) {
      return const SizedBox();
    }

    return Card(
      elevation: 0,
      color: const Color(0xFFF8F8FA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            'Faktor Kontribusi Utama',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          // leading icon removed as requested
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: explanation.topFactors.map((factor) {
            final label = HumanizedMapper.getLabel(factor.feature);
            final isIncreasing = factor.impact == 'increase_risk';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E5EA)),
              ),
              child: Row(
                children: [
                  Icon(
                    isIncreasing
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 20,
                    color: isIncreasing
                        ? const Color(0xFFFF375F)
                        : const Color(0xFF34C759),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                        Text(
                          HumanizedMapper.getRiskDescription(
                            label,
                            factor.value,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6E6E73),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }
}
