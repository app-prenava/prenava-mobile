import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/food_scan_result_model.dart';
import '../widgets/bounding_box_painter.dart';

class FoodScanResultPage extends StatefulWidget {
  final FoodScanApiResponse result;
  final String? imagePath;

  const FoodScanResultPage({
    super.key,
    required this.result,
    this.imagePath,
  });

  @override
  State<FoodScanResultPage> createState() => _FoodScanResultPageState();
}

class _FoodScanResultPageState extends State<FoodScanResultPage> {
  bool _showBoxes = true;

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SEIMBANG':
        return const Color(0xFF2E7D32);
      case 'CUKUP_SEIMBANG':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFFD32F2F);
    }
  }

  Color _parseHex(String hex) {
    String cleanHex = hex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    int val = int.tryParse(cleanHex, radix: 16) ?? 0xFF43A047;
    return Color(val);
  }

  @override
  Widget build(BuildContext context) {
    final analysis = widget.result.plateAnalysis;
    final summary = widget.result.summary;
    final items = widget.result.detectedItems;
    final statusColor = _getStatusColor(analysis.balanceStatus);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Hasil Analisis Piring'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _showBoxes ? Icons.visibility : Icons.visibility_off,
              color: AppColors.primaryPink,
            ),
            tooltip: _showBoxes ? 'Sembunyikan Bounding Box' : 'Tampilkan Bounding Box',
            onPressed: () {
              setState(() {
                _showBoxes = !_showBoxes;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Gambar dengan Bounding Box Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: widget.imagePath != null
                            ? (kIsWeb
                                ? Image.network(widget.imagePath!, fit: BoxFit.cover)
                                : Image.file(File(widget.imagePath!), fit: BoxFit.cover))
                            : (widget.result.imageUrl != null
                                ? Image.network(widget.result.imageUrl!, fit: BoxFit.cover)
                                : const Center(child: Icon(Icons.restaurant, size: 60, color: Colors.grey))),
                      ),
                      if (_showBoxes && items.isNotEmpty)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: BoundingBoxPainter(items: items),
                          ),
                        ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${items.length} Objek Terdeteksi (${summary.inferenceTimeMs.toStringAsFixed(0)} ms)',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 2. Score & Balance Status Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Lingkaran Skor
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withOpacity(0.12),
                        border: Border.all(color: statusColor, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${analysis.nutritionScore}',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: statusColor,
                              height: 1.0,
                            ),
                          ),
                          const Text(
                            '/ 100',
                            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              analysis.balanceStatus.replaceAll('_', ' '),
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            analysis.clinicalFeedback,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Obstetric Circuit Breaker Banner (Zat Besi / Heme-Iron)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: analysis.hasIronProtein ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: analysis.hasIronProtein ? const Color(0xFF81C784) : const Color(0xFFE57373),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      analysis.hasIronProtein ? Icons.shield_rounded : Icons.warning_amber_rounded,
                      color: analysis.hasIronProtein ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            analysis.hasIronProtein
                                ? 'Proteksi Zat Besi (Heme-Iron) Optimal'
                                : 'Peringatan Defisit Zat Besi Maternal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: analysis.hasIronProtein ? const Color(0xFF1B5E20) : const Color(0xFFB71C1C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            analysis.hasIronProtein
                                ? 'Piring makan terdeteksi memiliki sumber protein hewani bermutu tinggi untuk pembentukan sel darah merah & mencegah stunting.'
                                : 'Piring makan belum terdeteksi mengandung protein hewani. Sangat disarankan mengonsumsi lauk hewani atau minum Tablet Tambah Darah (TTD).',
                            style: TextStyle(
                              fontSize: 12,
                              color: analysis.hasIronProtein ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4. Koin Gamifikasi Reward Banner
              if (widget.result.coinReward.awarded)
                Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFB300)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF8F00),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reward Koin Diterima! (+50 Koin)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFE65100)),
                            ),
                            Text(
                              widget.result.coinReward.message ?? 'Koin telah ditambahkan ke dompet maternal Anda.',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF795548)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // 5. Proporsi 4 Kuadran "Isi Piringku" Kemenkes RI
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Distribusi Kuadran "Isi Piringku"',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        Text(
                          'Kemenkes RI',
                          style: TextStyle(fontSize: 12, color: AppColors.primaryPink, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...analysis.proportionBreakdown.entries.map((entry) {
                      final prop = entry.value;
                      final catColor = _parseHex(prop.colorHex);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: catColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      prop.label,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${prop.actualPercentage}% (Target: ${prop.targetPercentage}%)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: prop.status == 'SEIMBANG' ? const Color(0xFF2E7D32) : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: (prop.actualPercentage / 100.0).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade100,
                                valueColor: AlwaysStoppedAnimation<Color>(catColor),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 6. Objek Makanan Terdeteksi (Chips)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Makanan Dikenali Model',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    items.isEmpty
                        ? const Text('Tidak ada item makanan yang terdeteksi jelas.', style: TextStyle(color: Colors.grey, fontSize: 12))
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: items.map((item) {
                              final chipColor = _parseHex(item.colorHex);
                              return Chip(
                                avatar: CircleAvatar(
                                  backgroundColor: chipColor,
                                  radius: 6,
                                ),
                                label: Text(
                                  '${item.name} ${(item.confidence * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                                backgroundColor: chipColor.withOpacity(0.08),
                                side: BorderSide(color: chipColor.withOpacity(0.3)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 7. Rekomendasi Klinis Tindak Lanjut
              if (analysis.actionableRecommendations.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.checklist_rounded, color: AppColors.primaryPink, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Saran Perbaikan Piring',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...analysis.actionableRecommendations.map((rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.primaryPink, fontSize: 14, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    rec,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // 8. Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        side: const BorderSide(color: AppColors.primaryPink),
                      ),
                      child: const Text('Scan Piring Lain', style: TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Ke Beranda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
