import 'package:flutter/material.dart';

/// CustomPainter untuk membuat background pink dengan efek wave
class PinkWaveBackground extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double waveHeight;
  final double waveFrequency;

  PinkWaveBackground({
    this.primaryColor = const Color(0xFFFA6978),
    this.secondaryColor = const Color(0xFFE58DC5),
    this.waveHeight = 20.0,
    this.waveFrequency = 0.02,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor,
        secondaryColor,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Wave lines dengan efek transparan
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Multiple wave layers untuk efek depth
    for (double y = 0; y < size.height; y += waveHeight) {
      final path = Path();
      path.moveTo(0, y);

      // Menggunakan cubic bezier untuk wave yang lebih smooth
      for (double x = 0; x < size.width; x += 50) {
        final nextY = y + (waveHeight * 0.3 * (1 + (x / size.width)));
        path.cubicTo(
          x + 25,
          y + (waveHeight * 0.2 * (1 + (x / size.width))),
          x + 25,
          nextY,
          x + 50,
          nextY,
        );
      }

      canvas.drawPath(path, wavePaint);
    }

    // Additional subtle waves untuk efek lebih halus
    final subtlePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double y = waveHeight / 2; y < size.height; y += waveHeight) {
      final path = Path();
      path.moveTo(0, y);

      for (double x = 0; x < size.width; x += 50) {
        final nextY = y + (waveHeight * 0.2 * (1 + (x / size.width)));
        path.quadraticBezierTo(
          x + 25,
          y + (waveHeight * 0.15 * (1 + (x / size.width))),
          x + 50,
          nextY,
        );
      }

      canvas.drawPath(path, subtlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

