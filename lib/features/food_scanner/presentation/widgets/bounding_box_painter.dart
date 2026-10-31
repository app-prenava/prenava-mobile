import 'package:flutter/material.dart';
import '../../data/models/food_scan_result_model.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<DetectedFoodItemModel> items;
  final Size? imageSize;

  BoundingBoxPainter({
    required this.items,
    this.imageSize,
  });

  Color _parseHex(String hex, {double alpha = 1.0}) {
    String cleanHex = hex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      cleanHex = 'FF$cleanHex';
    }
    int val = int.tryParse(cleanHex, radix: 16) ?? 0xFF43A047;
    return Color(val).withOpacity(alpha);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    // Resolusi sumber (default YOLO standard 640x640 jika imageSize tidak spesifik)
    final double srcW = (imageSize != null && imageSize!.width > 0) ? imageSize!.width : 640.0;
    final double srcH = (imageSize != null && imageSize!.height > 0) ? imageSize!.height : 640.0;

    final double scaleX = size.width / srcW;
    final double scaleY = size.height / srcH;

    for (final item in items) {
      final box = item.box;
      final Color strokeColor = _parseHex(item.colorHex, alpha: 0.95);
      final Color fillColor = _parseHex(item.colorHex, alpha: 0.15);

      final left = box.x1 * scaleX;
      final top = box.y1 * scaleY;
      final right = box.x2 * scaleX;
      final bottom = box.y2 * scaleY;

      final rect = Rect.fromLTRB(left, top, right, bottom);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));

      // 1. Gambar Area Highlight Transparan
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, fillPaint);

      // 2. Gambar Border Bounding Box
      final strokePaint = Paint()
        ..color = strokeColor
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(rrect, strokePaint);

      // 3. Gambar Label Pill di atas kotak
      final String labelText = "${item.name} ${(item.confidence * 100).toInt()}%";
      final textSpan = TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.2,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelW = textPainter.width + 12;
      final labelH = textPainter.height + 6;
      final labelTop = (top - labelH - 2) < 0 ? top + 2 : top - labelH - 2;

      final labelRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, labelTop, labelW, labelH),
        const Radius.circular(6),
      );

      final bgPaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(labelRect, bgPaint);
      textPainter.paint(canvas, Offset(left + 6, labelTop + 3));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) {
    return oldDelegate.items != items || oldDelegate.imageSize != imageSize;
  }
}
