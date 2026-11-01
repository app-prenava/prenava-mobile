import 'package:flutter/foundation.dart';

@immutable
class NotificationItemModel {
  final int id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final String? createdAt;

  const NotificationItemModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.isRead = false,
    this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? 0;
    }

    Map<String, dynamic>? parsedData;
    if (json['data'] is Map) {
      parsedData = Map<String, dynamic>.from(json['data'] as Map);
    }

    return NotificationItemModel(
      id: parsedId,
      userId: json['user_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      title: json['title']?.toString() ?? 'Notifikasi',
      message: json['message']?.toString() ?? '',
      data: parsedData,
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at']?.toString(),
    );
  }

  NotificationItemModel copyWith({
    int? id,
    String? userId,
    String? type,
    String? title,
    String? message,
    Map<String, dynamic>? data,
    bool? isRead,
    String? createdAt,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
