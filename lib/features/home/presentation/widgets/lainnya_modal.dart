import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'menu_grid_item.dart';

class LainnyaModal extends StatelessWidget {
  final List<Widget>? items;

  const LainnyaModal({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    final children = (items != null && items!.isNotEmpty)
        ? items!
        : [
            MenuGridItem(
              imagePath: 'assets/images/calendar.png',
              label: 'Janji Temu',
              onTap: () {
                context.pop();
                context.push('/appointments');
              },
            ),
          ];

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
                mainAxisSpacing: 10,
                crossAxisSpacing: 6,
                childAspectRatio: 0.85,
                padding: EdgeInsets.zero,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
