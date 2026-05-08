import 'package:flutter/material.dart';

class MenuGridItem extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const MenuGridItem({
    super.key,
    this.icon,
    this.imagePath,
    required this.label,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
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
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: backgroundColor ?? const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: imagePath != null
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.image_not_supported,
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
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF424242),
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
