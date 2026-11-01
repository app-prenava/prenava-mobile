import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final bool isMine;

  const CommentCard({
    super.key,
    required this.comment,
    this.onReply,
    this.onDelete,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    final isBidan = comment.isBidanReply;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isBidan ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBidan ? const Color(0xFFBBF7D0) : Colors.grey.shade200,
          width: isBidan ? 1.5 : 1,
        ),
        boxShadow: isBidan
            ? [
                BoxShadow(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pinned Badge Header if it's a Midwife reply
          if (isBidan || comment.isPinned) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.push_pin, size: 12, color: Color(0xFF15803D)),
                      SizedBox(width: 4),
                      Text(
                        'Tanggapan Resmi Bidan Tersemat',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // User info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile image or Midwife Avatar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isBidan
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFA6978).withValues(alpha: 0.1),
                ),
                child: ClipOval(
                  child: isBidan
                      ? const Center(
                          child: Icon(
                            Icons.medical_services_outlined,
                            size: 18,
                            color: Color(0xFF16A34A),
                          ),
                        )
                      : (comment.user?.profileImage != null &&
                              comment.user!.profileImage!.isNotEmpty
                          ? Image.network(
                              comment.user!.profileImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultAvatar(),
                            )
                          : _buildDefaultAvatar()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            comment.user?.name ?? (isBidan ? 'Bidan Terverifikasi' : 'Pengguna Prenava'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isBidan ? const Color(0xFF14532D) : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isBidan) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Color(0xFF16A34A),
                          ),
                        ],
                      ],
                    ),
                    // If Bidan, show practice and SIPB
                    if (isBidan && comment.bidanProfile?.tempatPraktik != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${comment.bidanProfile!.tempatPraktik!} • ${comment.bidanProfile?.nomorSipb ?? 'SIPB Resmi'}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                    if (comment.createdAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(comment.createdAt!),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (onReply != null || (isMine && onDelete != null))
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'reply' && onReply != null) {
                      onReply!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) {
                    final items = <PopupMenuEntry<String>>[];
                    if (onReply != null) {
                      items.add(
                        const PopupMenuItem(
                          value: 'reply',
                          child: Text('Balas'),
                        ),
                      );
                    }
                    if (isMine && onDelete != null) {
                      items.add(
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus'),
                        ),
                      );
                    }
                    return items;
                  },
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Comment content
          Text(
            comment.komentar,
            style: TextStyle(
              fontSize: 13.5,
              color: isBidan ? const Color(0xFF0F172A) : Colors.black87,
              height: 1.5,
            ),
          ),

          // 1-Click Clinic Appointment Bridge
          if (isBidan && comment.suggestAppointment) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Rekomendasi Tindakan Klinis',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bidan menyarankan pemeriksaan fisik langsung untuk memastikan kondisi Bunda dan janin.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/appointments/create');
                      },
                      icon: const Icon(Icons.event_available, size: 16),
                      label: const Text(
                        'Buat Janji Temu dengan Bidan Ini',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFFFA6978).withValues(alpha: 0.15),
      child: const Icon(
        Icons.person,
        size: 18,
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
