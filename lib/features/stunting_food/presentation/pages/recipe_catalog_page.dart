import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../riverpod/stunting_food_providers.dart';
import '../widgets/stunting_food_ui.dart';

class RecipeCatalogPage extends ConsumerStatefulWidget {
  const RecipeCatalogPage({super.key});

  @override
  ConsumerState<RecipeCatalogPage> createState() => _RecipeCatalogPageState();
}

class _RecipeCatalogPageState extends ConsumerState<RecipeCatalogPage> {
  final _controller = TextEditingController();
  String? _search;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(foodsProvider(_search));

    return Scaffold(
      appBar: stuntingAppBar(title: 'Resep'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _controller,
              style: StuntingFoodTypo.body14(),
              decoration: InputDecoration(
                hintText: 'Cari resep / makanan...',
                hintStyle: StuntingFoodTypo.body14(color: StuntingFoodColors.textSecondary),
                prefixIcon: const Icon(Icons.search_outlined, color: StuntingFoodColors.textSecondary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  borderSide: const BorderSide(color: StuntingFoodColors.primaryPink, width: 1.5),
                ),
              ),
              onSubmitted: (v) =>
                  setState(() => _search = v.trim().isEmpty ? null : v.trim()),
            ),
          ),
          const Divider(height: 1, color: StuntingFoodColors.divider),
          Expanded(
            child: foodsAsync.when(
              loading: () => const LoadingShimmerList(),
              error: (e, _) => ErrorStateView(
                title: 'Gagal memuat katalog',
                subtitle: '$e',
                onRetry: () => ref.invalidate(foodsProvider(_search)),
              ),
              data: (foods) {
                if (foods.isEmpty) {
                  return EmptyStateView(
                    title: 'Tidak ada hasil',
                    subtitle: 'Coba kata kunci lain.',
                    ctaText: 'Reset',
                    onTap: () => setState(() {
                      _controller.clear();
                      _search = null;
                    }),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: foods.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final f = foods[i];
                    return AppCard(
                      child: InkWell(
                        onTap: () =>
                            context.push('/stunting-food/recipe', extra: f.id),
                        borderRadius: BorderRadius.circular(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    f.name,
                                    style: StuntingFoodTypo.heading16(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    f.category ?? '-',
                                    style: StuntingFoodTypo.caption12(),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: StuntingFoodColors.textSecondary,
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
      ),
    );
  }
}
