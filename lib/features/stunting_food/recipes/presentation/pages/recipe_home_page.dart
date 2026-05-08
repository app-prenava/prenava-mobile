import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../presentation/widgets/stunting_food_ui.dart';
import '../riverpod/recipes_providers.dart';

import '../widgets/recipe_image.dart';

class RecipeHomePage extends ConsumerStatefulWidget {
  final String? initialSearch;
  const RecipeHomePage({super.key, this.initialSearch});

  @override
  ConsumerState<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends ConsumerState<RecipeHomePage> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.initialSearch != null && widget.initialSearch!.trim().isNotEmpty) {
        _searchCtrl.text = widget.initialSearch!.trim();
        ref
            .read(recipeListNotifierProvider.notifier)
            .setSearchDebounced(_searchCtrl.text);
      }
      await ref.read(recipeListNotifierProvider.notifier).initDefaultCategory();
    });

    _scrollCtrl.addListener(() {
      final position = _scrollCtrl.position;
      if (!position.hasPixels || !position.hasContentDimensions) return;
      final threshold = position.maxScrollExtent * 0.7;
      if (position.pixels >= threshold) {
        ref.read(recipeListNotifierProvider.notifier).loadMoreIfNeeded();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(recipeCategoriesProvider);
    final listState = ref.watch(recipeListNotifierProvider);
    final listNotifier = ref.read(recipeListNotifierProvider.notifier);

    return Scaffold(
      appBar: stuntingAppBar(title: 'Resep'),
      body: Column(
        children: [
          // Warning banner
          if (listState.warning != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: StuntingFoodColors.lightPinkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: StuntingFoodColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: StuntingFoodColors.primaryPink,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        listState.warning!,
                        style: StuntingFoodTypo.body13(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => listNotifier.setSearchDebounced(v),
              style: StuntingFoodTypo.body14(),
              decoration: InputDecoration(
                hintText: 'Cari resep / makanan...',
                hintStyle: StuntingFoodTypo.body14(
                  color: StuntingFoodColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_outlined,
                  color: StuntingFoodColors.textSecondary,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: StuntingFoodColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: StuntingFoodColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: StuntingFoodColors.primaryPink,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                // Toggle
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        listNotifier.setHasFoodInfoOnly(!listState.hasFoodInfoOnly),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: listState.hasFoodInfoOnly
                            ? Colors.white
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: StuntingFoodColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            listState.hasFoodInfoOnly
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            size: 18,
                            color: listState.hasFoodInfoOnly
                                ? StuntingFoodColors.primaryPink
                                : StuntingFoodColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Ada Gizi & Gambar',
                              style: StuntingFoodTypo.caption12(
                                color: listState.hasFoodInfoOnly
                                    ? StuntingFoodColors.primaryPink
                                    : StuntingFoodColors.textPrimary,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Sort Icon
                PopupMenuButton<String>(
                  onSelected: (v) => listNotifier.setSort(v),
                  offset: const Offset(0, 45),
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: StuntingFoodColors.border),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: StuntingFoodColors.textPrimary,
                      size: 20,
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'popular',
                      child: Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: listState.sort == 'popular'
                                ? StuntingFoodColors.primaryPink
                                : StuntingFoodColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Populer',
                            style: StuntingFoodTypo.body14(
                              weight: listState.sort == 'popular'
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'newest',
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 18,
                            color: listState.sort == 'newest'
                                ? StuntingFoodColors.primaryPink
                                : StuntingFoodColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Terbaru',
                            style: StuntingFoodTypo.body14(
                              weight: listState.sort == 'newest'
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category chips
          categoriesAsync.when(
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: const LinearProgressIndicator(
                  minHeight: 2,
                  color: StuntingFoodColors.primaryPink,
                ),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ErrorStateView(
                title: 'Gagal memuat kategori',
                subtitle: recipesFriendlyError(e),
                onRetry: () => ref.invalidate(recipeCategoriesProvider),
              ),
            ),
            data: (categories) {
              if (categories.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((c) {
                      final selected = listState.category == c.category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => listNotifier.setCategory(c.category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? StuntingFoodColors.primaryPink
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? StuntingFoodColors.primaryPink
                                    : StuntingFoodColors.border,
                              ),
                            ),
                            child: Text(
                              '${c.category} (${c.total})',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : StuntingFoodColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),

          const Divider(height: 1, color: StuntingFoodColors.divider),

          // Recipe list
          Expanded(
            child: _buildList(context, listState, listNotifier),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    RecipeListState state,
    RecipeListNotifier notifier,
  ) {
    if (state.loading && state.items.isEmpty) {
      return const LoadingShimmerList();
    }

    if (state.error != null && state.items.isEmpty) {
      return ErrorStateView(
        title: 'Gagal memuat resep',
        subtitle: state.error!,
        onRetry: notifier.refresh,
      );
    }

    if (state.items.isEmpty) {
      return EmptyStateView(
        title: 'Tidak ada resep',
        subtitle: 'Coba ganti kategori atau reset pencarian.',
        ctaText: 'Reset',
        onTap: () {
          _searchCtrl.clear();
          notifier.setSearchDebounced('');
        },
      );
    }

    return RefreshIndicator(
      color: StuntingFoodColors.primaryPink,
      onRefresh: notifier.refresh,
      child: ListView.separated(
        controller: _scrollCtrl,
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length + (state.loadingMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: CircularProgressIndicator(
                  color: StuntingFoodColors.primaryPink,
                ),
              ),
            );
          }

          final r = state.items[index];
          return AppCard(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: () {
                if (r.id <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recipe ID tidak valid.')),
                  );
                  return;
                }
                context.push('/stunting-food/recipe', extra: r.id);
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      RecipeImage(
                        imageUrl: r.foodImageUrl,
                        category: r.category ?? r.foodCategory,
                        width: double.infinity,
                        height: 220,
                        borderRadius: 16,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.title.toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${r.category ?? r.foodCategory ?? "RESEP"} • ${r.calories?.toStringAsFixed(0) ?? "0"} KCAL',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (r.hasFoodInfo) ...[
                          Row(
                            children: [
                              if (r.calories != null)
                                _buildNutrientLabel(
                                  '${r.calories!.toStringAsFixed(0)} kcal',
                                  Icons.local_fire_department_rounded,
                                ),
                              if (r.calories != null && r.protein != null)
                                const SizedBox(width: 16),
                              if (r.protein != null)
                                _buildNutrientLabel(
                                  '${r.protein!.toStringAsFixed(0)}g protein',
                                  Icons.egg_alt_rounded,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          'Ketuk untuk melihat detail bahan dan cara pembuatan resep ini secara lengkap.',
                          style: StuntingFoodTypo.body13(
                            color: StuntingFoodColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNutrientLabel(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: StuntingFoodColors.primaryPink),
        const SizedBox(width: 4),
        Text(
          text,
          style: StuntingFoodTypo.caption12(
            color: StuntingFoodColors.textSecondary,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


