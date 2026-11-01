import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../notification/presentation/providers/notification_providers.dart';
import '../../../notification/data/models/notification_item_model.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifState = ref.watch(notificationNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (notifState.unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(notificationNotifierProvider.notifier).markAllAsRead();
              },
              child: const Text(
                'Tandai dibaca',
                style: TextStyle(
                  color: Color(0xFFFA6978),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(notificationNotifierProvider.notifier).loadNotifications(),
        color: const Color(0xFFFA6978),
        child: notifState.isLoading && notifState.notifications.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFA6978),
                ),
              )
            : notifState.notifications.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: notifState.notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = notifState.notifications[index];
                      return _buildNotificationCard(context, ref, item);
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 72,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada notifikasi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Kami akan memberitahu Anda saat ada advis\ndari Bidan atau aktivitas penting lainnya',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    WidgetRef ref,
    NotificationItemModel item,
  ) {
    final isMedical = item.type == 'bidan_forum_reply';

    return GestureDetector(
      onTap: () {
        if (!item.isRead) {
          ref.read(notificationNotifierProvider.notifier).markAsRead(item.id);
        }

        // Jika notifikasi tanggapan bidan pada forum, buka thread terkait
        if (item.data != null && item.data!['post_id'] != null) {
          final postId = item.data!['post_id'];
          context.push('/community/detail/$postId');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.isRead ? Colors.grey.shade200 : const Color(0xFFBBF7D0),
            width: item.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isMedical
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFFA6978).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMedical ? Icons.medical_services_outlined : Icons.notifications_outlined,
                size: 20,
                color: isMedical ? const Color(0xFF16A34A) : const Color(0xFFFA6978),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: isMedical ? const Color(0xFF14532D) : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF16A34A),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  if (item.createdAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(item.createdAt!),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
