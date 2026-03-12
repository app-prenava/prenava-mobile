import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/anemia_scan_providers.dart';

class AnemiaResultPage extends ConsumerWidget {
  const AnemiaResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(anemiaScanNotifierProvider);
    final result = state.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hasil Analisis')),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    if (result.error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D3748)),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Hasil Analisis',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F5),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFEB2B2), width: 2),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Color(0xFFE53E3E),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Terjadi Kesalahan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(anemiaScanNotifierProvider.notifier).reset();
                      context.pop();
                    },
                    icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                    label: const Text(
                      'Coba Lagi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF06292),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Determine emotional state based on parsed prediction
    String predictionState = result.prediction.toUpperCase();
    String description = 'Berdasarkan analisis area mata, ini adalah indikasi awal yang ditemukan.';
    Color primaryColor = const Color(0xFF48BB78); // Green
    IconData primaryIcon = Icons.health_and_safety_rounded;

    if (predictionState.contains("ANEMIA") && !predictionState.contains("NON")) {
      description = 'Terdapat indikasi Anemia. Konsultasikan dengan profesional kesehatan atau bidan Anda untuk pemeriksaan darah lanjutan.';
      primaryColor = const Color(0xFFE53E3E); // Red
      primaryIcon = Icons.warning_amber_rounded;
    } else if (predictionState.contains("NON")) {
       predictionState = "TIDAK ANEMIA";
       description = 'Area mata tampak normal dan tidak menunjukkan tanda-tanda Anemia pucat.';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D4A7A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Eye Scan Check',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header area with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF0F5), Colors.white],
                  stops: [0.0, 0.6],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  children: [
                    const Text(
                      'Eye Scan Analysis',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF06292),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Review your personalized results below',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Photo preview
                    if (state.selectedImagePath != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: SizedBox(
                            height: 240,
                            width: double.infinity,
                            child: Image.file(
                              File(state.selectedImagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Analysis Summary Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Analysis Summary',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Emotional State
                      Row(
                        children: [
                          const Text(
                            'Indikator Anemia:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A5568),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(primaryIcon, color: primaryColor, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        predictionState,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Divider
                      const Divider(color: Color(0xFFEDF2F7), thickness: 1),
                      const SizedBox(height: 16),

                      // Metrics Section
                      const Text(
                        'Detail Prediksi:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildMetricRow(
                          'Confidence Score',
                          result.confidence != null
                              ? '${(result.confidence! * 100).toStringAsFixed(1)}%'
                              : 'N/A'),
                      const SizedBox(height: 8),
                      _buildMetricRow(
                          'Probabilitas Anemia',
                          result.probabilityAnemia != null
                              ? '${(result.probabilityAnemia! * 100).toStringAsFixed(1)}%'
                              : 'N/A',
                          isAlert: result.probabilityAnemia != null && result.probabilityAnemia! > 0.4968),
                      const SizedBox(height: 8),
                      _buildMetricRow(
                          'Probabilitas Non-Anemia',
                          result.probabilityNonAnemia != null
                              ? '${(result.probabilityNonAnemia! * 100).toStringAsFixed(1)}%'
                              : 'N/A'),
                      const SizedBox(height: 8),
                      _buildMetricRow(
                          'Threshold Output',
                          result.thresholdUsed != null
                              ? result.thresholdUsed!.toStringAsFixed(4)
                              : '0.4968'),

                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Disclaimer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '* Hasil scan bukan diagnosis medis. Konsultasikan dengan profesional kesehatan atau bidan Anda.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Take New Photo button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(anemiaScanNotifierProvider.notifier).reset();
                        context.pop();
                      },
                      icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                      label: const Text(
                        'Take New Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF06292), // Primary Pink
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {bool isAlert = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isAlert ? const Color(0xFFE53E3E) : const Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}
