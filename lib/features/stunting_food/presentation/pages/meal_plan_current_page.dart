import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../riverpod/stunting_food_providers.dart';
import '../widgets/meal_plan_preferences.dart';
import '../widgets/stunting_food_ui.dart';

class MealPlanCurrentPage extends ConsumerStatefulWidget {
  final int? predictionIdForCreate;

  const MealPlanCurrentPage({super.key, this.predictionIdForCreate});

  @override
  ConsumerState<MealPlanCurrentPage> createState() =>
      _MealPlanCurrentPageState();
}

class _MealPlanCurrentPageState extends ConsumerState<MealPlanCurrentPage> {
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: _buildBody(context, state, notifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MealPlanCurrentState state,
    MealPlanCurrentNotifier notifier,
  ) {
    if (state.loading) {
      return const SafeArea(child: LoadingShimmerList());
    }

    if (state.error != null && state.plan == null) {
      return SafeArea(
        child: ErrorStateView(
          title: 'Gagal memuat meal plan',
          subtitle: state.error!,
          onRetry: notifier.load,
        ),
      );
    }

    final plan = state.plan;
    if (plan == null) {
      return SafeArea(
        child: EmptyStateView(
          title: 'Belum ada meal plan',
          subtitle: 'Buat meal plan untuk memulai progres nutrisi harian.',
          ctaText: 'Buat Meal Plan',
          onTap: () => _createWithPreferences(context, notifier),
        ),
      );
    }

    final day = plan.days.firstWhere(
      (d) => d.dayIndex == state.selectedDayIndex,
      orElse: () => plan.days.first,
    );

    final now = DateTime.now();
    final dateFormatted = DateFormat('d MMM yyyy', 'id').format(now);

    final completed = plan.completionSummary.completedItems;
    final total = plan.completionSummary.totalItems;
    final progress = total == 0 ? 0.0 : completed / total;
    final kalori = completed * 350;
    final protein = completed * 34;

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
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        dateFormatted,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune_rounded, color: Color(0xFF2D3142)),
                        onPressed: () => _openPreferences(context),
                      ),
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
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[100],
                        valueColor: const AlwaysStoppedAnimation(StuntingFoodColors.primaryPink),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_fire_department, color: Color(0xFF2D3142), size: 24),
                        const SizedBox(height: 4),
                        Text(
                          '$kalori',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D3142),
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'Kcal Consumed',
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
                
                // See Stats Text
                Text(
                  'Lihat Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3142).withValues(alpha: 0.8),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2D3142)),
                const SizedBox(height: 10),

                // Stats Cards
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn('Protein', '${protein}g', progress, StuntingFoodColors.primaryPink),
                      _buildStatColumn('Kalori', '${kalori}kcal', progress, Colors.blue),
                      _buildStatColumn('Item', '$completed/$total', progress, Colors.orange),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Section
        Expanded(
          child: RefreshIndicator(
            color: StuntingFoodColors.primaryPink,
            onRefresh: notifier.load,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Header & Day Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rencana Hari Ini',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2D3142),
                          ),
                        ),
                        Text(
                          '$completed/$total item selesai',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_month, color: Color(0xFF4F5E7B)),
                      onPressed: () {
                         context.push('/stunting-food/meal-plan/progress', extra: plan.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Lihat Menu Tersedia',
                  onPressed: () => _showAvailableMenusBottomSheet(context, null),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                
                // Horizontal Day Selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(plan.days.length, (i) {
                      final active = state.selectedDayIndex == i;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => notifier.selectDay(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50,
                            height: 70,
                            decoration: BoxDecoration(
                              color: active ? StuntingFoodColors.primaryPink : Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _dayLabel(i),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                                    color: active ? Colors.white : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: active ? Colors.white : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: active ? StuntingFoodColors.primaryPink : const Color(0xFF2D3142),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                // Timeline List
                ...day.meals.map((item) {
                  return _buildTimelineItem(item, notifier, context);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(dynamic item, MealPlanCurrentNotifier notifier, BuildContext context) {
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
    
    final slot = item.slot.toLowerCase();
    final timeStr = mealTimeMap[slot] ?? '10:00';
    final nameStr = mealNameMap[slot] ?? item.slot;
    final isCompleted = item.isCompleted;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Time
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  timeStr,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: 1,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nameStr,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.food.name,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push('/stunting-food/recipe', extra: item.itemId);
                              },
                              child: Text(
                                'Lihat Resep',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: StuntingFoodColors.primaryPink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => _showAvailableMenusBottomSheet(context, item.itemId),
                              child: Text(
                                'Ganti Menu',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => notifier.toggleCompletionOptimistic(
                      itemId: item.itemId,
                      value: !isCompleted,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? Colors.blue : Colors.transparent,
                        border: Border.all(
                          color: isCompleted ? Colors.blue : Colors.grey[400]!,
                          width: 1.5,
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                        child: isCompleted
                            ? const Icon(Icons.check, key: ValueKey(true), size: 16, color: Colors.white)
                            : const Icon(Icons.add, key: ValueKey(false), size: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dayLabel(int index) {
    const labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return labels[index % labels.length];
  }



  void _showAvailableMenusBottomSheet(BuildContext context, int? targetItemId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final foodsAsync = ref.watch(foodsProvider(null));

                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menu yang Tersedia',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2D3142),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: StuntingFoodColors.divider),
                    Expanded(
                      child: foodsAsync.when(
                        loading: () => const LoadingShimmerList(),
                        error: (e, _) => ErrorStateView(
                          title: 'Gagal memuat resep',
                          subtitle: '$e',
                          onRetry: () => ref.invalidate(foodsProvider(null)),
                        ),
                        data: (foods) {
                          if (foods.isEmpty) {
                            return EmptyStateView(
                              title: 'Tidak ada resep',
                              subtitle: 'Gunakan kata kunci lain.',
                              ctaText: 'Kembali',
                              onTap: () => Navigator.pop(context),
                            );
                          }

                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            itemCount: foods.length,
                            itemBuilder: (context, index) {
                              final food = foods[index];
                              return Card(
                                color: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: Colors.grey[200]!),
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          food.imageUrl ?? 'https://via.placeholder.com/150',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Container(
                                            width: 70,
                                            height: 70,
                                            color: Colors.grey[100],
                                            child: const Icon(Icons.restaurant, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              food.name,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF2D3142),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                if (food.category != null) ...[
                                                  _buildFoodStat(food.category!),
                                                  const SizedBox(width: 8),
                                                ],
                                                _buildFoodStat('${food.calories.round()} Kcal'),
                                                const SizedBox(width: 8),
                                                _buildFoodStat('${food.protein}g Pro'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {
                                          if (targetItemId != null) {
                                            ref.read(mealPlanCurrentNotifierProvider.notifier).replaceItemOptimistic(
                                              itemId: targetItemId,
                                              newFood: food,
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${food.name} berhasil diganti'),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${food.name} dipilih untuk jadwal ini'),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          }
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: StuntingFoodColors.primaryPink,
                                          textStyle: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        child: const Text('Pilih'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFoodStat(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Future<void> _createWithPreferences(
    BuildContext context,
    MealPlanCurrentNotifier notifier,
  ) async {
    final predictionId = widget.predictionIdForCreate;
    if (predictionId == null) return;

    final prefs = await MealPlanPreferences.load();
    if (!context.mounted) return;

    final updated = await showModalBottomSheet<MealPlanPreferences>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PreferencesSheet(initial: prefs),
    );

    final finalPrefs = updated ?? prefs;
    await finalPrefs.save();

    // NOTE: backend contract belum mendukung preferensi. Saat ini hanya "days" yang dipakai.
    await notifier.createFromPrediction(predictionId, days: finalPrefs.days);
  }

  Future<void> _openPreferences(BuildContext context) async {
    final prefs = await MealPlanPreferences.load();
    if (!context.mounted) return;
    final updated = await showModalBottomSheet<MealPlanPreferences>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _PreferencesSheet(initial: prefs),
    );
    if (updated != null) {
      await updated.save();
      final plan = ref.read(mealPlanCurrentNotifierProvider).plan;
      if (plan != null && context.mounted) {
        // Recreation to apply the new days length
        await ref.read(mealPlanCurrentNotifierProvider.notifier).createFromPrediction(
          plan.predictionId, 
          days: updated.days,
        );
      }
    }
  }
}



// --- Preferences Sheet ---

class _PreferencesSheet extends StatefulWidget {
  final MealPlanPreferences initial;
  const _PreferencesSheet({required this.initial});

  @override
  State<_PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends State<_PreferencesSheet> {
  late int days = widget.initial.days;
  late bool sukaDaging = widget.initial.sukaDaging;
  late bool sukaSayur = widget.initial.sukaSayur;
  late bool sukaIkan = widget.initial.sukaIkan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Preferensi Meal Plan',
              style: StuntingFoodTypo.heading18(),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Atur durasi dan pantangan makanan.',
              style: StuntingFoodTypo.body14(
                color: StuntingFoodColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durasi plan',
                  style: StuntingFoodTypo.body14(weight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: StuntingFoodColors.primaryPink,
                          inactiveTrackColor: Colors.grey.shade200,
                          thumbColor: StuntingFoodColors.primaryPink,
                          overlayColor: StuntingFoodColors.primaryPink.withValues(alpha: 0.15),
                        ),
                        child: Slider(
                          value: days.toDouble(),
                          min: 7,
                          max: 14,
                          divisions: 7,
                          onChanged: (v) => setState(() => days = v.round()),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: StuntingFoodColors.border),
                      ),
                      child: Text(
                        '$days hari',
                        style: StuntingFoodTypo.body14(
                          color: StuntingFoodColors.primaryDarkPink,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: StuntingFoodColors.divider),
                _switchTile(
                  'Suka Daging',
                  sukaDaging,
                  (v) => setState(() => sukaDaging = v),
                ),
                _switchTile(
                  'Suka Sayur',
                  sukaSayur,
                  (v) => setState(() => sukaSayur = v),
                ),
                _switchTile(
                  'Suka Ikan / Seafood',
                  sukaIkan,
                  (v) => setState(() => sukaIkan = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Simpan',
            onPressed: () {
              Navigator.pop(
                context,
                MealPlanPreferences(
                  days: days,
                  sukaDaging: sukaDaging,
                  sukaSayur: sukaSayur,
                  sukaIkan: sukaIkan,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      activeThumbColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey[100],
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.green;
        }
        return Colors.grey[300];
      }),
      title: Text(title, style: StuntingFoodTypo.body14()),
      onChanged: onChanged,
    );
  }
}
