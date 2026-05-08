import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../stunting_food/presentation/riverpod/stunting_food_providers.dart';

class MealPlanHomeWidget extends ConsumerStatefulWidget {
  const MealPlanHomeWidget({super.key});

  @override
  ConsumerState<MealPlanHomeWidget> createState() => _MealPlanHomeWidgetState();
}

class _MealPlanHomeWidgetState extends ConsumerState<MealPlanHomeWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealPlanCurrentNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealPlanCurrentNotifierProvider);
    final notifier = ref.read(mealPlanCurrentNotifierProvider.notifier);

    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: Color(0xFFFA6978))),
      );
    }

    if (state.plan == null) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Belum ada Meal Plan aktif.\nSilakan buat Meal Plan dari menu Risiko Stunting.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final day = state.plan!.days.firstWhere(
      (d) => d.dayIndex == state.selectedDayIndex,
      orElse: () => state.plan!.days.first,
    );

    final mealTimeMap = {
      'breakfast': '07:00',
      'sarapan': '07:00',
      'lunch': '12:30',
      'makan_siang': '12:30',
      'snack': '15:30',
      'camilan': '15:30',
      'dinner': '19:00',
      'makan_malam': '19:00',
    };

    final mealNameMap = {
      'breakfast': 'Sarapan',
      'sarapan': 'Sarapan',
      'lunch': 'Makan Siang',
      'makan_siang': 'Makan Siang',
      'snack': 'Camilan',
      'camilan': 'Camilan',
      'dinner': 'Makan Malam',
      'makan_malam': 'Makan Malam',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Makan Hari Ini',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          ...day.meals.map((item) {
            final slot = item.slot.toLowerCase();
            final timeStr = mealTimeMap[slot] ?? '10:00';
            final nameStr = mealNameMap[slot] ?? item.slot;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: GestureDetector(
                  onTap: () => notifier.toggleCompletionOptimistic(
                    itemId: item.itemId,
                    value: !item.isCompleted,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.isCompleted ? Colors.green.withValues(alpha: 0.1) : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        item.isCompleted ? Icons.check : Icons.radio_button_off,
                        key: ValueKey(item.isCompleted),
                        color: item.isCompleted ? Colors.green : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '$timeStr - $nameStr',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: item.isCompleted ? Colors.grey : const Color(0xFF424242),
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  item.food.name,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
