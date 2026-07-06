import 'package:flutter/material.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';

class StuntingMealPlanPage extends StatelessWidget {
  final AiMealPlanResponse response;

  const StuntingMealPlanPage({super.key, required this.response});

  bool get isWeekly => response.rekomendasiMenu.containsKey('senin') || response.rekomendasiMenu.containsKey('Senin');

  @override
  Widget build(BuildContext context) {
    if (isWeekly) {
      final days = ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu', 'minggu'];
      // Try to find matching keys (case-insensitive)
      final availableDays = <String>[];
      final dayData = <String, AiMenuRecommendation>{};

      for (var expectedDay in days) {
        for (var key in response.rekomendasiMenu.keys) {
          if (key.toLowerCase() == expectedDay) {
            availableDays.add(key);
            dayData[key] = AiMenuRecommendation.fromJson(response.rekomendasiMenu[key]);
            break;
          }
        }
      }

      return DefaultTabController(
        length: availableDays.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Rekomendasi Menu'),
            bottom: TabBar(
              isScrollable: true,
              tabs: availableDays.map((d) => Tab(text: d.toUpperCase())).toList(),
            ),
          ),
          body: TabBarView(
            children: availableDays.map((d) {
              return _buildDailyView(dayData[d]!);
            }).toList(),
          ),
        ),
      );
    } else {
      // Single day
      final dailyMenu = AiMenuRecommendation.fromJson(response.rekomendasiMenu);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rekomendasi Menu'),
        ),
        body: _buildDailyView(dailyMenu),
      );
    }
  }

  Widget _buildDailyView(AiMenuRecommendation menuData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Analisis Gizi'),
          ...response.analisisGizi.map((gizi) => _buildGiziCard(gizi)),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Rekomendasi Menu'),
          _buildMenuCard('Sarapan', menuData.sarapan, Icons.wb_sunny_outlined),
          _buildMenuCard('Makan Siang', menuData.makanSiang, Icons.wb_twilight_outlined),
          _buildMenuCard('Makan Malam', menuData.makanMalam, Icons.nights_stay_outlined),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Saran Personal'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: response.saranAi.map((saran) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(saran)),
                  ],
                ),
              )).toList(),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            response.catatan,
            style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGiziCard(AiNutritionAnalysis gizi) {
    final isGood = gizi.status.toLowerCase().contains('terpenuhi');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(gizi.nutrisi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isGood ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    gizi.status,
                    style: TextStyle(
                      color: isGood ? Colors.green.shade800 : Colors.red.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Kebutuhan: ${gizi.kebutuhan}'),
            Text('Asupan: ${gizi.asupan}'),
            const SizedBox(height: 4),
            Text(
              gizi.catatan,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, AiMeal meal, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.orange),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            ...meal.menu.map((m) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(m, style: const TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
            )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Alasan: ${meal.alasan}',
                style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
