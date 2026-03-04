import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String statusText;
    IconData? icon;

    switch (status.toLowerCase()) {
      case 'requested':
      case 'pending':
        backgroundColor = Colors.white;
        textColor = const Color(0xFFFF9800);
        statusText = 'Menunggu';
        icon = Icons.pending;
        break;
      case 'accepted':
        backgroundColor = Colors.white;
        textColor = const Color(0xFF4CAF50);
        statusText = 'Diterima';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        backgroundColor = Colors.white;
        textColor = const Color(0xFFF44336);
        statusText = 'Ditolak';
        icon = Icons.cancel;
        break;
      case 'completed':
        backgroundColor = Colors.white;
        textColor = const Color(0xFF2196F3);
        statusText = 'Selesai';
        icon = Icons.done_all;
        break;
      case 'cancelled':
        backgroundColor = Colors.white;
        textColor = Colors.grey;
        statusText = 'Dibatalkan';
        icon = Icons.block;
        break;
      default:
        backgroundColor = Colors.white;
        textColor = Colors.grey;
        statusText = status;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
