import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../riverpod/stunting_food_providers.dart';
import '../widgets/stunting_food_ui.dart';

class MealPlanHistoryPage extends ConsumerWidget {
  const MealPlanHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncHistory = ref.watch(mealPlanHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: stuntingAppBar(title: 'Riwayat Meal Plan'),
      body: asyncHistory.when(
        loading: () => const LoadingShimmerList(),
        error: (e, _) => ErrorStateView(
          title: 'Gagal memuat riwayat',
          subtitle: '$e',
          onRetry: () => ref.invalidate(mealPlanHistoryProvider),
        ),
        data: (plans) {
          if (plans.isEmpty) {
            return EmptyStateView(
              title: 'Riwayat masih kosong',
              subtitle: 'Meal plan yang sudah dibuat akan muncul di sini.',
              ctaText: 'Lihat Plan Aktif',
              onTap: () => context.push('/stunting-food/meal-plan/current'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'Plan #${plan.id}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                  subtitle: Text(
                    'Progress: ${(plan.completionSummary.totalItems > 0 ? plan.completionSummary.completedItems / plan.completionSummary.totalItems * 100 : 0).toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          final repo = ref.read(stuntingFoodRepositoryProvider);
                          try {
                            await repo.deleteMealPlan(plan.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Meal plan berhasil dihapus')),
                              );
                              ref.invalidate(mealPlanHistoryProvider);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal menghapus: $e')),
                              );
                            }
                          }
                        },
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  onTap: () {
                    context.push('/stunting-food/meal-plan/progress', extra: plan.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
