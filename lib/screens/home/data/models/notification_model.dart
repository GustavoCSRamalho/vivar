// models/notification_model.dart
import 'dart:convert';

class NotificationModel {
  final String id;
  final String userId;
  final String type; // 'offer', 'checkin', 'badge', 'system'
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;
  final bool synced;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.isRead = false,
    required this.createdAt,
    this.synced = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      title: map['title'],
      message: map['message'],
      data: map['data'] != null ? jsonDecode(map['data']) : null,
      isRead: map['is_read'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'data': data != null ? jsonEncode(data) : null,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }
}
