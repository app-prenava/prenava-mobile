import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../riverpod/stunting_food_providers.dart';
import '../widgets/stunting_food_ui.dart';

class FoodRecommendationPage extends ConsumerWidget {
  final int predictionId;
  const FoodRecommendationPage({super.key, required this.predictionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(stuntingRecommendationProvider(predictionId));

    return Scaffold(
      appBar: stuntingAppBar(
        title: 'Rekomendasi',
      ),
      body: asyncData.when(
        loading: () => const LoadingShimmerList(),
        error: (e, _) => ErrorStateView(
          title: 'Gagal memuat rekomendasi',
          subtitle: '$e',
          onRetry: () =>
              ref.invalidate(stuntingRecommendationProvider(predictionId)),
        ),
        data: (bundle) {
          return RefreshIndicator(
            color: StuntingFoodColors.primaryPink,
            onRefresh: () async {
              ref.invalidate(stuntingRecommendationProvider(predictionId));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // --- Risk Summary Banner ---
                _RiskBanner(
                  isHighRisk: bundle.summary.riskLabel == 'high_risk',
                  probability: bundle.summary.probability,
                ),
                const SizedBox(height: 16),

                // --- Preference CTA banner (non-blocking) ---
                if (bundle.needsPreferences) ...[
                  _PreferenceCta(
                    message: bundle.message,
                    questions: bundle.preferenceQuestions,
                    onTap: () => context.push(
                      '/stunting-food/preferences',
                      extra: predictionId,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // --- Recommended Foods List ---
                if (bundle.foods.isNotEmpty) ...[
                  Text(
                    'Makanan yang Direkomendasikan',
                    style: StuntingFoodTypo.heading16(),
                  ),
                  const SizedBox(height: 12),
                  ...bundle.foods.map(
                    (rf) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FoodRecommendationCard(
                        name: rf.food.name,
                        category: rf.food.category,
                        imageUrl: rf.food.imageUrl,
                        calories: rf.food.calories,
                        protein: rf.food.protein,
                        iron: rf.food.iron,
                        calcium: rf.food.calcium,
                        reason: rf.reason,
                        hasRecipe: rf.hasRecipe,
                        onTap: rf.hasRecipe
                            ? () => context.push(
                                  '/stunting-food/recipes',
                                  extra: {'search': rf.food.name},
                                )
                            : null,
                      ),
                    ),
                  ),
                  // "Lihat Semua" link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/stunting-food/recipes'),
                      child: Text(
                        'Lihat Semua',
                        style: StuntingFoodTypo.body14(
                          color: StuntingFoodColors.primaryPink,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ] else ...[
                  // Empty state
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rekomendasi makanan sedang disiapkan',
                          style: StuntingFoodTypo.heading16(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kamu tetap bisa membuat meal plan dan eksplor resep sambil menunggu.',
                          style: StuntingFoodTypo.body14(
                            color: StuntingFoodColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // --- Action Buttons ---
                PrimaryButton(
                  text: 'Buat Meal Plan',
                  onPressed: () {
                    context.push(
                      '/stunting-food/meal-plan/current',
                      extra: predictionId,
                    );
                  },
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  text: 'Buka Resep',
                  icon: Icons.menu_book_outlined,
                  onPressed: () => context.push('/stunting-food/recipes'),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}

// --- Risk Banner Widget ---

class _RiskBanner extends StatelessWidget {
  final bool isHighRisk;
  final double probability;
  const _RiskBanner({required this.isHighRisk, required this.probability});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighRisk
              ? StuntingFoodColors.primaryPink
              : StuntingFoodColors.success,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isHighRisk
                ? Icons.warning_amber_outlined
                : Icons.check_circle_outline_rounded,
            color: isHighRisk
                ? StuntingFoodColors.primaryDarkPink
                : StuntingFoodColors.success,
            size: 32,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHighRisk ? 'Risiko Stunting Tinggi' : 'Risiko Stunting Rendah',
                  style: StuntingFoodTypo.heading16(
                    color: isHighRisk
                        ? StuntingFoodColors.primaryDarkPink
                        : StuntingFoodColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Probabilitas ${(probability * 100).toStringAsFixed(1)}%',
                  style: StuntingFoodTypo.body14(
                    color: isHighRisk
                        ? StuntingFoodColors.primaryDarkPink
                        : StuntingFoodColors.success,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Preference CTA Widget ---

class _PreferenceCta extends StatelessWidget {
  final String? message;
  final List<String> questions;
  final VoidCallback onTap;

  const _PreferenceCta({
    this.message,
    required this.questions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StuntingFoodColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: StuntingFoodColors.primaryPink,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message ?? 'Lengkapi preferensi untuk rekomendasi lebih personal',
                  style: StuntingFoodTypo.body14(weight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (questions.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...questions.take(3).map(
                  (q) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $q',
                      style: StuntingFoodTypo.body13(),
                    ),
                  ),
                ),
          ],
          const SizedBox(height: 12),
          SecondaryButton(
            text: 'Atur Preferensi',
            icon: Icons.tune_outlined,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
