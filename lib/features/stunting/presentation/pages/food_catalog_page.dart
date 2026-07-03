import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/core/theme/app_theme.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final foodCatalogProvider = FutureProvider<List<FoodModel>>((ref) {
  final repository = ref.watch(stuntingRepositoryProvider);
  return repository.getFoods();
});

class FoodCatalogPage extends ConsumerStatefulWidget {
  const FoodCatalogPage({super.key});

  @override
  ConsumerState<FoodCatalogPage> createState() => _FoodCatalogPageState();
}

class _FoodCatalogPageState extends ConsumerState<FoodCatalogPage> {
  bool _isGeminiLoading = false;

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(foodCatalogProvider);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Katalog Makanan Bergizi'),
            backgroundColor: Colors.white,
          ),
          body: catalogAsync.when(
            data: (foods) {
              if (foods.isEmpty) {
                return const Center(child: Text('Belum ada data makanan.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return _buildFoodCard(context, food);
                },
              );
            },
            loading: () => _buildLoadingState(),
            error: (err, stack) => Center(child: Text('Gagal memuat katalog: $err')),
          ),
        ),
        if (_isGeminiLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodModel food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF5F5F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (food.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.imageUrl!,
                width: 80,
                height: 80,
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildNutrientTag('${food.calories.round()} kkal'),
                    const SizedBox(width: 8),
                    _buildNutrientTag('Protein: ${food.protein}g'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.restaurant_rounded, color: AppColors.primaryPink, size: 32),
    );
  }

  Widget _buildNutrientTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryPink),
      ),
    );
  }
}
