import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../riverpod/stunting_food_providers.dart';
import '../widgets/meal_widgets.dart';
import '../widgets/stunting_food_ui.dart';

class MealPlanProgressPage extends ConsumerWidget {
  final int mealPlanId;
  const MealPlanProgressPage({super.key, required this.mealPlanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(mealPlanProgressProvider(mealPlanId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: asyncData.when(
        loading: () => const SafeArea(child: LoadingShimmerList()),
        error: (e, _) => SafeArea(
          child: ErrorStateView(
            title: 'Gagal memuat progress',
            subtitle: '$e',
            onRetry: () => ref.invalidate(mealPlanProgressProvider(mealPlanId)),
          ),
        ),
        data: (p) {
          final overallPercent = p.overall.totalItems == 0
              ? 0.0
              : p.overall.completedItems / p.overall.totalItems;

          return Column(
            children: [
              // Top Section (White Background)
              Container(
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Custom App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              'Progress Meal Plan',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(width: 48), // Balance for center title
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Circular Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: overallPercent,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey[100],
                              valueColor: const AlwaysStoppedAnimation(StuntingFoodColors.primaryPink),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(overallPercent * 100).round()}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF2D3142),
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                'Overall Progress',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF2D3142).withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${p.overall.completedItems}/${p.overall.totalItems} item selesai',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D3142).withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Bottom Section (List)
              Expanded(
                child: RefreshIndicator(
                  color: StuntingFoodColors.primaryPink,
                  onRefresh: () async {
                    ref.invalidate(mealPlanProgressProvider(mealPlanId));
                  },
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    children: [
                      Text(
                        'Progress Harian',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...p.daily.map((d) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProgressTile(
                            dayIndex: d.dayIndex,
                            completedItems: d.completedItems,
                            totalItems: d.totalItems,
                            completionPercentage: d.completionPercentage,
                            isCompleted: d.isDayCompleted,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
