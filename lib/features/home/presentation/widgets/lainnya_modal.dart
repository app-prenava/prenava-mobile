import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/feature_tracker_provider.dart';
import 'menu_grid_item.dart';

class LainnyaModal extends ConsumerWidget {
  const LainnyaModal({super.key});

  void _navigate(
    BuildContext context,
    WidgetRef ref,
    String route, {
    AppFeature? feature,
  }) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    if (feature != null) {
      ref.read(featureTrackerProvider).track(feature);
    }
    router.push(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu & Layanan Lainnya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Fitur dan panduan pendukung kesehatan ibu & si kecil',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 6,
                childAspectRatio: 0.85,
                padding: EdgeInsets.zero,
                children: [
                  MenuGridItem(
                    imagePath: 'assets/images/tips.png',
                    label: 'Tips & Gizi',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/tips',
                      feature: AppFeature.tips,
                    ),
                  ),
                  MenuGridItem(
                    imagePath: 'assets/images/calendar.png',
                    label: 'Janji Temu',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/appointments',
                      feature: AppFeature.appointment,
                    ),
                  ),
                  MenuGridItem(
                    icon: Icons.support_agent_rounded,
                    label: 'Tanya Bidan AI',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/maternal-rag',
                    ),
                  ),
                  MenuGridItem(
                    imagePath: 'assets/images/kunjungan.png',
                    label: 'Kunjungan ANC',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/kunjungan',
                      feature: AppFeature.kunjungan,
                    ),
                  ),
                  MenuGridItem(
                    icon: Icons.location_on_outlined,
                    label: 'Lokasi Bidan',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/bidan-map',
                    ),
                  ),
                  MenuGridItem(
                    icon: Icons.restaurant_menu_rounded,
                    label: 'Resep Nutrisi',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/stunting-food/recipes',
                    ),
                  ),
                  MenuGridItem(
                    icon: Icons.medical_information_outlined,
                    label: 'Riwayat Medis',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/health/history',
                    ),
                  ),
                  MenuGridItem(
                    imagePath: 'assets/images/stunting icon.png',
                    label: 'Skrining Anak',
                    onTap: () => _navigate(
                      context,
                      ref,
                      '/stunting/screening',
                      feature: AppFeature.stunting,
                    ),
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
