import 'package:flutter/material.dart';

class MenuGridItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isRecommended;
  final String? badgeText;

  const MenuGridItem({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.isRecommended = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: backgroundColor ?? const Color(0xFFFCE4EC),
                    borderRadius: BorderRadius.circular(16),
                    border: isRecommended
                        ? Border.all(
                            color: const Color(0xFFFA6978),
                            width: 1.6,
                          )
                        : null,
                  ),
                  child: Center(
                    child: imagePath != null
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              imagePath!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                icon ?? Icons.apps,
                                color: iconColor ?? const Color(0xFFFA6978),
                                size: 26,
                              ),
                            ),
                          )
                        : Icon(
                            icon ?? Icons.apps,
                            color: iconColor ?? const Color(0xFFFA6978),
                            size: 26,
                          ),
                  ),
                ),
                if (isRecommended)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA6978),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFA6978).withValues(alpha: 0.35),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        badgeText ?? 'Utama',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isRecommended ? FontWeight.w700 : FontWeight.w500,
                  color: const Color(0xFF424242),
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
