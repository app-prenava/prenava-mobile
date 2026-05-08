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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleCookingGuide(food),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryPink,
                      elevation: 0,
                      side: const BorderSide(color: AppColors.primaryPink, width: 1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cara Masak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
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

  Future<void> _handleCookingGuide(FoodModel food) async {
    setState(() => _isGeminiLoading = true);
    try {
      final repository = ref.read(stuntingRepositoryProvider);
      final guide = await repository.getCookingGuide([food.name]);
      if (mounted) {
        setState(() => _isGeminiLoading = false);
        _showGuideDialog(context, food.name, guide.cookingGuide ?? 'Tidak ada instruksi tersedia.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGeminiLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal meminta instruksi memasak: $e')),
        );
      }
    }
  }

  void _showGuideDialog(BuildContext context, String foodName, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppColors.primaryPink),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cara Memasak $foodName',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Markdown(
                    controller: scrollController,
                    data: content,
                    padding: const EdgeInsets.all(24),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
