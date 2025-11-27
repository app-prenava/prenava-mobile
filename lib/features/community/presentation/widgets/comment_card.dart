import 'package:flutter/material.dart';
import '../../domain/entities/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              // Profile image
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFA6978).withOpacity(0.1),
                ),
                child: ClipOval(
                  child: comment.user?.profileImage != null &&
                          comment.user!.profileImage!.isNotEmpty
                      ? Image.network(
                          comment.user!.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.user?.name ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (comment.createdAt != null)
                      Text(
                        _formatDate(comment.createdAt!),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Comment text
          Text(
            comment.komentar,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFFA6978).withOpacity(0.2),
      child: const Icon(
        Icons.person,
        size: 16,
        color: Color(0xFFFA6978),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) {
        return 'Baru saja';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} menit lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} jam lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} hari lalu';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (_) {
      return dateStr;
    }
  }
}

