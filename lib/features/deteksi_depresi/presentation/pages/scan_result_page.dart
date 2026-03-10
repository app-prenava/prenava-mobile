import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/depression_scan_result.dart';
import '../providers/depression_scan_providers.dart';

class ScanResultPage extends ConsumerWidget {
  const ScanResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(depressionScanNotifierProvider);
    final result = state.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hasil Analisis')),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    if (!result.faceDetected) {
      return _buildNoFaceDetected(context, state, ref);
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
          'Mental Health Check',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
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
                      'Face Scan Analysis',
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
              child: _buildAnalysisSummaryCard(result),
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
                  '* ${result.disclaimer ?? "Hasil scan bukan diagnosis medis. Konsultasikan dengan profesional kesehatan."}',
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
                        ref.read(depressionScanNotifierProvider.notifier).reset();
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
                  const SizedBox(height: 12),
                  // Share Results
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Share Results',
                      style: TextStyle(
                        color: Color(0xFFF06292),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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

  String _getIndicatorLabel(double percentage) {
    if (percentage <= 20) return 'Very Low';
    if (percentage <= 40) return 'Low';
    if (percentage <= 60) return 'Moderate';
    if (percentage <= 80) return 'High';
    return 'Very High';
  }

  Widget _buildAnalysisSummaryCard(DepressionScanResult result) {
    final score = result.score ?? 0.0;
    final fatigueProb = result.fatigueProbabilities?['Fatigue'] ?? 0.0;
    final happyProb = result.expressionProbabilities?['Happy'] ?? 0.0;
    final sadProb = result.expressionProbabilities?['Sad'] ?? 0.0;
    final neutralProb = result.expressionProbabilities?['Neutral'] ?? 0.0;
    final calmScore = (happyProb + neutralProb) * 100;
    final stressScore = (sadProb + (result.expressionProbabilities?['Fear'] ?? 0.0) +
            (result.expressionProbabilities?['Angry'] ?? 0.0)) *
        100;

    // Determine emotional state based on raw depression score (higher is worse)
    String emotionalState;
    String emotionalDescription;
    Color emotionalColor;
    IconData emotionalIcon;

    if (score <= 33) {
      emotionalState = 'Indikasi Depresi Rendah';
      emotionalDescription =
          'Kondisi mental terlihat baik. Tetap jaga pola hidup sehat.';
      emotionalColor = const Color(0xFF48BB78);
      emotionalIcon = Icons.sentiment_satisfied_alt;
    } else if (score <= 66) {
      emotionalState = 'Indikasi Depresi Sedang';
      emotionalDescription =
          'Terdeteksi beberapa indikator. Fokus pada istirahat dan kelola stres.';
      emotionalColor = const Color(0xFFED8936);
      emotionalIcon = Icons.access_time_rounded;
    } else {
      emotionalState = 'Indikasi Depresi Tinggi';
      emotionalDescription =
          'Perlu perhatian lebih. Konsultasikan dengan profesional kesehatan.';
      emotionalColor = const Color(0xFFE53E3E);
      emotionalIcon = Icons.warning_amber_rounded;
    }

    return Container(
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

            // Wellbeing Score + Expression Indicators
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Depression Score
                Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        painter: _DepressionScorePainter(score / 100),
                        child: Center(
                          child: Text(
                            '${score.round()}%',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD81B60), // Darker pink for text
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Skor Depresi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    Text(
                      '(0-100)',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Right: Expression Indicators
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expression Indicators',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildIndicator(
                        'Fatigue',
                        _getIndicatorLabel(fatigueProb * 100),
                        fatigueProb,
                        '${(fatigueProb * 100).round()}%',
                        const Color(0xFF48BB78),
                      ),
                      const SizedBox(height: 10),
                      _buildIndicator(
                        'Calm',
                        _getIndicatorLabel(100 - calmScore),
                        calmScore / 100,
                        '${calmScore.round()}%',
                        const Color(0xFFF06292),
                      ),
                      const SizedBox(height: 10),
                      _buildIndicator(
                        'Stress',
                        _getIndicatorLabel(stressScore),
                        stressScore / 100,
                        '${stressScore.round()}%',
                        const Color(0xFFF06292),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Divider
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 16),

            // Emotional State
            Row(
              children: [
                const Text(
                  'Emotional State',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A5568),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(emotionalIcon, color: emotionalColor, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              emotionalState,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: emotionalColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              emotionalDescription,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(
    String label,
    String levelText,
    double value,
    String percentage,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$label, ',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                    TextSpan(
                      text: levelText,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildNoFaceDetected(
    BuildContext context,
    DepressionScanState state,
    WidgetRef ref,
  ) {
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
                  Icons.face_retouching_off,
                  size: 48,
                  color: Color(0xFFE53E3E),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Wajah Tidak Terdeteksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.result?.error ??
                    'Pastikan wajah terlihat jelas dan cahaya cukup.',
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
                    ref.read(depressionScanNotifierProvider.notifier).reset();
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
}

class _DepressionScorePainter extends CustomPainter {
  final double progress;

  _DepressionScorePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Color gradient based on score (higher = red, lower = green)
    if (progress >= 0.67) {
      progressPaint.color = const Color(0xFFE53E3E);
    } else if (progress >= 0.34) {
      progressPaint.color = const Color(0xFFED8936);
    } else {
      progressPaint.color = const Color(0xFF48BB78);
    }

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DepressionScorePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
