import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String? status;

  const StatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String statusText;
    IconData icon;

    switch (status?.toLowerCase()) {
      case 'normal':
        backgroundColor = const Color(0xFF4CAF50).withValues(alpha: 0.1);
        textColor = const Color(0xFF4CAF50);
        statusText = 'Normal';
        icon = Icons.check_circle;
        break;
      case 'peringatan':
      case 'perlu perhatian':
        backgroundColor = const Color(0xFFFF9800).withValues(alpha: 0.1);
        textColor = const Color(0xFFFF9800);
        statusText = 'Perlu Perhatian';
        icon = Icons.warning;
        break;
      case 'bahaya':
      case 'segera ke bidan':
        backgroundColor = const Color(0xFFF44336).withValues(alpha: 0.1);
        textColor = const Color(0xFFF44336);
        statusText = 'Segera ke Bidan';
        icon = Icons.error;
        break;
      default:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[600]!;
        statusText = status ?? 'Tidak Diketahui';
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
