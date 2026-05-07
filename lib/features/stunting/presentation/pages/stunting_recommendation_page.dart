import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/core/theme/app_theme.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/presentation/providers/stunting_providers.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class StuntingRecommendationPage extends ConsumerWidget {
  final int predictionId;

  const StuntingRecommendationPage({super.key, required this.predictionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stuntingRecommendationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rekomendasi & Rencana Makan'),
        backgroundColor: Colors.white,
      ),
      body: state.isLoading
          ? _buildLoadingState()
          : state.error != null
              ? _buildErrorState(state.error!)
              : state.data == null
                  ? const Center(child: Text('Data tidak tersedia'))
                  : _buildContent(context, state.data!),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 100, width: double.infinity, color: Colors.white),
            const SizedBox(height: 24),
            Container(height: 20, width: 200, color: Colors.white),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(height: 80, width: double.infinity, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Container(height: 300, width: double.infinity, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(child: Text('Gagal memuat rekomendasi: $error'));
  }

  Widget _buildContent(BuildContext context, RecommendationData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryHeader(data.predictionSummary),
          const SizedBox(height: 32),
          const Text(
            'Bahan Makanan yang Disarankan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...data.recommendedFoods.map((food) => _buildFoodCard(food)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push('/stunting/foods'),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Lihat Semua Katalog Makanan'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: AppColors.primaryPink,
                side: const BorderSide(color: AppColors.primaryPink),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (data.aiSupport != null) ...[
            _buildAiSection(
              title: 'Rencana Makan Sehat',
              icon: Icons.calendar_today_rounded,
              content: data.aiSupport!.mealPlan,
            ),
            const SizedBox(height: 24),
            _buildAiSection(
              title: 'Panduan Memasak & Tips',
              icon: Icons.restaurant_menu_rounded,
              content: data.aiSupport!.cookingGuide ?? data.aiSupport!.nutritionTips,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(PredictionSummary summary) {
    final isHighRisk = summary.riskLabel == 'high_risk';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryPink, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primaryPink, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fokus Nutrisi Bunda',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  isHighRisk
                      ? 'Rekomendasi ini disusun khusus untuk membantu menurunkan risiko stunting.'
                      : 'Pertahankan status gizi Anda dengan pilihan makanan bernutrisi tinggi berikut.',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodModel food) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (food.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  food.imageUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildFoodPlaceholder(),
                ),
              )
            else
              _buildFoodPlaceholder(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildNutrientTag('Protein: ${food.protein}g'),
                      _buildNutrientTag('${food.calories.round()} kkal'),
                    ],
                  ),
                  if (food.reason != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      food.reason!,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.restaurant, color: Colors.grey),
    );
  }

  Widget _buildNutrientTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryPink),
      ),
    );
  }

  Widget _buildAiSection({required String title, required IconData icon, String? content}) {
    if (content == null || content.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryPink, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: MarkdownBody(
            data: content,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: AppColors.textPrimary, height: 1.5, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
