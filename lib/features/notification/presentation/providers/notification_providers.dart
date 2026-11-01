import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/notification_item_model.dart';

class NotificationState {
  final bool isLoading;
  final List<NotificationItemModel> notifications;
  final int unreadCount;
  final String? error;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
    this.unreadCount = 0,
    this.error,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationItemModel>? notifications,
    int? unreadCount,
    String? error,
    bool clearError = false,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super(const NotificationState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = _ref.read(appDioProvider);
      final response = await dio.get('/notifications');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> items = response.data['data'] ?? [];
        final notifications = items
            .map((item) => NotificationItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();

        final unreadCount = response.data['unread_count'] as int? ??
            notifications.where((n) => !n.isRead).length;

        state = state.copyWith(
          isLoading: false,
          notifications: notifications,
          unreadCount: unreadCount,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      final dio = _ref.read(appDioProvider);
      await dio.post('/notifications/$notificationId/read');

      final updated = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final newUnread = state.unreadCount > 0 ? state.unreadCount - 1 : 0;
      state = state.copyWith(notifications: updated, unreadCount: newUnread);
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      final dio = _ref.read(appDioProvider);
      await dio.post('/notifications/read-all');

      final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      state = state.copyWith(notifications: updated, unreadCount: 0);
    } catch (_) {}
  }
}

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});
