import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../presentation/widgets/stunting_food_ui.dart';

String _normalizeCategory(String? category) {
  final c = (category ?? '').toLowerCase();
  if (c.contains('ayam')) return 'ayam';
  if (c.contains('ikan')) return 'ikan';
  if (c.contains('telur')) return 'telur';
  if (c.contains('tempe')) return 'tempe';
  if (c.contains('tahu')) return 'tahu';
  if (c.contains('udang')) return 'udang';
  if (c.contains('sapi')) return 'sapi';
  if (c.contains('kambing')) return 'kambing';
  return 'default';
}

IconData _iconForCategory(String cat) {
  switch (cat) {
    case 'ayam':
      return Icons.dinner_dining_rounded;
    case 'ikan':
      return Icons.set_meal_rounded;
    case 'telur':
      return Icons.egg_alt_rounded;
    case 'tempe':
    case 'tahu':
      return Icons.spa_rounded;
    case 'udang':
      return Icons.restaurant_rounded;
    case 'sapi':
    case 'kambing':
      return Icons.lunch_dining_rounded;
    default:
      return Icons.restaurant_menu_rounded;
  }
}

class RecipeImage extends StatelessWidget {
  final String? imageUrl;
  final String? category;
  final double? width;
  final double? height;
  final double borderRadius;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    required this.category,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final cat = _normalizeCategory(category);
    final placeholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: StuntingFoodColors.border),
      ),
      child: Icon(
        _iconForCategory(cat),
        color: StuntingFoodColors.primaryPink,
        size: (height ?? 64) * 0.42,
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }
}

