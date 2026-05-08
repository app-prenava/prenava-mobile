import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/meal_plan.dart';
import 'stunting_food_ui.dart';

String mapMealSlotLabel(String slot) {
  switch (slot) {
    case 'breakfast':
      return 'Sarapan';
    case 'lunch':
      return 'Makan Siang';
    case 'dinner':
      return 'Makan Malam';
    case 'snack':
      return 'Camilan';
    default:
      return slot;
  }
}

IconData _slotIcon(String slot) {
  switch (slot) {
    case 'breakfast':
      return Icons.wb_sunny_outlined;
    case 'lunch':
      return Icons.restaurant_outlined;
    case 'dinner':
      return Icons.nightlight_outlined;
    case 'snack':
      return Icons.cookie_outlined;
    default:
      return Icons.dining_outlined;
  }
}

class MealSlotTile extends StatelessWidget {
  final MealPlanFoodItem item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onViewRecipe;

  const MealSlotTile({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onViewRecipe,
  });

  @override
  Widget build(BuildContext context) {
    final label = mapMealSlotLabel(item.slot);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: item.isCompleted,
              activeColor: StuntingFoodColors.primaryPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: const BorderSide(color: StuntingFoodColors.border, width: 1.5),
              onChanged: (v) => onToggle(v ?? false),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Slot label
                Row(
                  children: [
                    Icon(
                      _slotIcon(item.slot),
                      size: 14,
                      color: StuntingFoodColors.primaryPink,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: StuntingFoodTypo.caption12(
                        color: StuntingFoodColors.primaryPink,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Food name
                Text(
                  item.food.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: item.isCompleted
                        ? StuntingFoodColors.textSecondary
                        : StuntingFoodColors.textPrimary,
                    decoration:
                        item.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                // Nutrient + focus
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    NutrientChip(item.focusNutrient),
                  ],
                ),
                const SizedBox(height: 8),
                // View recipe link
                InkWell(
                  onTap: onViewRecipe,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat Resep',
                          style: StuntingFoodTypo.caption12(
                            color: StuntingFoodColors.primaryPink,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: StuntingFoodColors.primaryPink,
                        ),
                      ],
                    ),
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

class ProgressTile extends StatelessWidget {
  final int dayIndex;
  final int completedItems;
  final int totalItems;
  final int completionPercentage;
  final bool isCompleted;

  const ProgressTile({
    super.key,
    required this.dayIndex,
    required this.completedItems,
    required this.totalItems,
    required this.completionPercentage,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final barColor =
        isCompleted ? StuntingFoodColors.success : StuntingFoodColors.primaryPink;

    return AppCard(
      child: Row(
        children: [
          // Day label circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted
                  ? StuntingFoodColors.successBg
                  : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted
                    ? StuntingFoodColors.success
                    : StuntingFoodColors.border,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${dayIndex + 1}',
              style: StuntingFoodTypo.heading16(
                color: isCompleted
                    ? StuntingFoodColors.success
                    : StuntingFoodColors.primaryPink,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Progress info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hari ${dayIndex + 1}',
                      style: StuntingFoodTypo.body14(weight: FontWeight.w600),
                    ),
                    Text(
                      '$completedItems/$totalItems selesai',
                      style: StuntingFoodTypo.caption12(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: completionPercentage / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$completionPercentage%',
                    style: StuntingFoodTypo.caption12(
                      color: barColor,
                      weight: FontWeight.w600,
                    ),
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
