import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/food_scan_providers.dart';

class FoodScannerPage extends ConsumerStatefulWidget {
  const FoodScannerPage({super.key});

  @override
  ConsumerState<FoodScannerPage> createState() => _FoodScannerPageState();
}

class _FoodScannerPageState extends ConsumerState<FoodScannerPage> {
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodScanNotifierProvider.notifier).reset();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 88,
      );
      if (picked != null) {
        ref.read(foodScanNotifierProvider.notifier).setImagePath(picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: AppColors.warningRed,
          ),
        );
      }
    }
  }

  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Color(0xFFFB8C00)),
            SizedBox(width: 8),
            Text('Panduan Foto Piring', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agar AI Computer Vision dapat mengenali makanan dengan akurat:', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            _TipRow(icon: Icons.camera_alt_outlined, text: 'Ambil foto dari atas piring (sudut 90° tegak lurus).'),
            SizedBox(height: 8),
            _TipRow(icon: Icons.wb_sunny_outlined, text: 'Pastikan pencahayaan terang dan tidak banyak bayangan gelap.'),
            SizedBox(height: 8),
            _TipRow(icon: Icons.crop_free, text: 'Seluruh piring dan makanan berada di dalam bingkai kamera.'),
            SizedBox(height: 8),
            _TipRow(icon: Icons.egg_alt_outlined, text: 'Pastikan lauk protein hewani (ayam, telur, ikan) terlihat jelas.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mengerti', style: TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodScanNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Isi Piringku (Food Scanner)'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.primaryPink),
            onPressed: _showTipsDialog,
            tooltip: 'Panduan Pemotretan',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Guidance Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryPink.withOpacity(0.08),
                      const Color(0xFFFF85C2).withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryPink.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.restaurant_menu, color: AppColors.primaryPink, size: 26),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Standar "Isi Piringku" Kemenkes RI',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'AI mendeteksi proporsi 4 kuadran makanan dan asupan zat besi untuk mencegah anemia maternal.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Image Box / Preview
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: const Radius.circular(20),
                    color: state.selectedImagePath != null
                        ? AppColors.primaryPink
                        : Colors.grey.shade300,
                    strokeWidth: 2,
                    dashPattern: const [8, 5],
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: state.selectedImagePath != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                kIsWeb
                                    ? Image.network(
                                        state.selectedImagePath!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(state.selectedImagePath!),
                                        fit: BoxFit.cover,
                                      ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.65),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                                        SizedBox(width: 6),
                                        Text('Foto Siap', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFA6978).withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_enhance_rounded,
                                    size: 48,
                                    color: AppColors.primaryPink,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Pilih atau Ambil Foto Piring Makan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Ketuk untuk memilih dari Galeri atau Kamera',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Button Row: Kamera & Galeri
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isScanning ? null : () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, color: AppColors.primaryPink),
                      label: const Text('Buka Kamera', style: TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primaryPink),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isScanning ? null : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library, color: AppColors.primaryPink),
                      label: const Text('Buka Galeri', style: TextStyle(color: AppColors.primaryPink, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primaryPink),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Error notification if any
              if (state.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.warningRed.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warningRed.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.warningRed, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: AppColors.warningRed, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Call To Action: Analisis Gizi Piring
              ElevatedButton(
                onPressed: (state.selectedImagePath == null || state.isScanning)
                    ? null
                    : () async {
                        final result = await ref.read(foodScanNotifierProvider.notifier).analyzePlate();
                        if (!context.mounted) return;
                        if (result != null) {
                          context.push(
                            '/food-scanner/result',
                            extra: {
                              'result': result,
                              'imagePath': state.selectedImagePath,
                            },
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: state.isScanning
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'AI Menganalisis Piring...',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Analisis Isi Piringku Sekarang',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),

              // Gamification Incentive Card (+50 Koin Dinkes)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Color(0xFFFB8C00), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reward Kepatuhan: +50 Koin',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFE65100)),
                          ),
                          Text(
                            'Dapatkan 50 Koin Maternal setiap piring makan terverifikasi Seimbang atau Cukup Seimbang.',
                            style: TextStyle(fontSize: 12, color: Colors.brown.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryPink),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
