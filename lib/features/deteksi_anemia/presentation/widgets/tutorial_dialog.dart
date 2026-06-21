import 'package:flutter/material.dart';

/// Tutorial Dialog for Anemia Detection Feature
///
/// Displays comprehensive tutorial with 3 instructional tips for taking
/// a quality anemia detection photo. Styled consistently with Deteksi Depresi.
///
/// Shows on first app launch and can be re-displayed via info button.
class TutorialDialog extends StatelessWidget {
  /// Callback when user dismisses the tutorial
  final VoidCallback? onDismiss;

  const TutorialDialog({
    this.onDismiss,
    super.key,
  });

  /// Helper widget for building tutorial instruction rows
  Widget _buildTutorialRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFFFA6978), // Primary pink
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2D3748), // Dark text
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFFA6978), // Primary pink
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Panduan Deteksi Anemia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748), // Dark text
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Subtitle/description
              const Text(
                'Kesehatan darah selama kehamilan sangatlah penting. Fitur ini dirancang untuk mendeteksi indikator anemia dari warna konjungtiva mata Anda.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5568), // Secondary text
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Tutorial rows (3 items)
              _buildTutorialRow(
                Icons.remove_red_eye_rounded,
                'Fokus pada area konjungtiva (putih mata bagian bawah kelopak)',
              ),
              const SizedBox(height: 12),
              _buildTutorialRow(
                Icons.lightbulb_outline,
                'Pastikan pencahayaan cukup terang dan merata',
              ),
              const SizedBox(height: 12),
              _buildTutorialRow(
                Icons.videocam,
                'Hindari gerakan kamera agar foto tidak blur',
              ),
              const SizedBox(height: 12),
              _buildTutorialRow(
                Icons.shield_rounded,
                'Privasi terjaga. Foto disimpan lokal di perangkat Anda.',
              ),
              const SizedBox(height: 24),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismiss?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6978), // Primary pink
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
