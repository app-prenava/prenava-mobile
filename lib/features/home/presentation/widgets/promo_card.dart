import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const PromoCard({
    super.key,
    this.imageUrl,
    this.title,
    this.backgroundColor = const Color(0xFFFFE8EC),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 280,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholderContent(),
                ),
              )
            : _placeholderContent(),
      ),
    );
  }

  Widget _placeholderContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.card_giftcard,
            size: 48,
            color: Color(0xFFFA6978),
          ),
          if (title != null) ...[
            const SizedBox(height: 12),
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFA6978),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

