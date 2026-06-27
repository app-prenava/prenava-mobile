import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/stunting_food_ui.dart';
import '../../recipes/presentation/riverpod/recipes_providers.dart';
import '../../recipes/presentation/utils/recipe_text_parser.dart';
import '../../recipes/presentation/widgets/recipe_image.dart';

class RecipeDetailPage extends ConsumerStatefulWidget {
  final int recipeId;
  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final asyncDetail = ref.watch(recipeDetailProvider(widget.recipeId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recipe',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? StuntingFoodColors.primaryPink : Colors.black,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: asyncDetail.when(
        loading: () => const LoadingShimmerList(),
        error: (e, _) => ErrorStateView(
          title: 'Gagal memuat detail resep',
          subtitle: recipesFriendlyError(e),
          onRetry: () => ref.invalidate(recipeDetailProvider(widget.recipeId)),
        ),
        data: (detail) {
          if (detail == null) {
            return EmptyStateView(
              title: 'Resep tidak ditemukan',
              subtitle: 'Coba cari resep lain dari katalog.',
              ctaText: 'Kembali ke Resep',
              onTap: () => Navigator.of(context).pop(),
            );
          }

          final recipe = detail.recipe;
          final food = detail.food;
          final ingredients = parseRecipeParts(recipe.ingredients);
          final steps = parseRecipeParts(recipe.steps);
          // final sourceUrl = normalizeSourceUrl(recipe.sourceUrl);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Hero Image ---
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: RecipeImage(
                      imageUrl: food?.imageUrl,
                      category: food?.category ?? recipe.category,
                      width: double.infinity,
                      height: 400,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Title & Author ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        recipe.title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '4.8',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Description ---
                if ((food?.description ?? '').trim().isNotEmpty)
                  Text(
                    food!.description!.trim(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: 24),

                // --- Stats Row ---
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.grey[100]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Prep', '${(steps.length * 3).clamp(10, 60)} Min'),
                      _buildStatDivider(),
                      _buildStat('Calories', '${food?.calories.toStringAsFixed(0) ?? '-'} Kcal'),
                      _buildStatDivider(),
                      _buildStat('Difficulty', steps.length > 7 ? 'Hard' : (steps.length > 4 ? 'Medium' : 'Easy')),
                      _buildStatDivider(),
                      _buildStat('Serves', '1-2'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // --- Ingredients (Expandable) ---
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    title: Text(
                      'Ingredients',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                    initiallyExpanded: true,
                    children: [
                      const SizedBox(height: 8),
                      ...ingredients.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

                // --- Instructions (Expandable) ---
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    title: Text(
                      'Instructions',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                    children: [
                      const SizedBox(height: 8),
                      ...steps.asMap().entries.map((entry) {
                        final i = entry.key + 1;
                        final step = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: StuntingFoodColors.primaryPink,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$i',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  step,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // Space for button
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Resep berhasil disimpan ke koleksi!'),
                    backgroundColor: StuntingFoodColors.primaryPink,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Simpan ke Koleksi',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3142),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.grey[200],
    );
  }
}



