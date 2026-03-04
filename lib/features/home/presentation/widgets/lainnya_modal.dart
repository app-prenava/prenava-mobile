import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'menu_grid_item.dart';

class LainnyaModal extends StatelessWidget {
  const LainnyaModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menu Lainnya',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 6,
                childAspectRatio: 0.85,
                padding: EdgeInsets.zero,
                children: [
                  MenuGridItem(
                    imagePath: 'assets/images/calendar.png',
                    label: 'Janji Temu',
                    onTap: () {
                      context.pop(); // Close modal first
                      context.push('/appointments');
                    },
                  ),
                  MenuGridItem(
                    // Using an existing image temporarily or we can use a Flutter icon for now.
                    // Let's use 'assets/images/tips.png' as a placeholder if no specific image exists for Rekomendasi Gerakan.
                    // Actually, the user might want a specific image, but I will use a placeholder for now.
                    // Wait, let's use a Flutter Icon since it's cleaner if no image exists. No, MenuGridItem expects an imagePath.
                    // I will use `assets/images/tips.png` for now.
                    imagePath: 'assets/images/tips.png',
                    label: 'Rekomendasi Gerakan',
                    onTap: () {
                      context.pop(); // Close modal first
                      context.push('/rekomendasi-gerakan');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
