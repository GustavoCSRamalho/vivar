// domain/entities/notification_entity.dart

class NotificationEntity {
  final String id;
  final String userId;
  final String type; // 'offer', 'checkin', 'badge', 'social', 'system'
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.data,
  });
}
