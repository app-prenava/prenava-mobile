import 'package:flutter/material.dart';

class HydrationGlassItem extends StatelessWidget {
  final bool filled;
  final VoidCallback? onTap;

  const HydrationGlassItem({
    super.key,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          );
        },
        child: Opacity(
          opacity: onTap == null ? 0.6 : 1.0,
          child: Image.asset(
            filled
                ? 'assets/images/glass water.png'
                : 'assets/images/glass empty.png',
            key: ValueKey(filled),
            width: 56,
            height: 56,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback jika asset tidak ditemukan
              return Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: filled ? Colors.blue[200] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: filled ? Colors.blue : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.local_drink,
                  color: filled ? Colors.blue[700] : Colors.grey[400],
                  size: 30,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

