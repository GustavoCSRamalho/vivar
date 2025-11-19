// domain/repositories/notifications_repository_protocol.dart

import '../entities/notification_entity.dart';

abstract class NotificationsRepositoryProtocol {
  Future<List<NotificationEntity>> getNotifications(String userId);
  Future<List<NotificationEntity>> getNotificationsByType(
    String userId,
    String type,
  );
  Future<void> markAsRead(String notificationId, String userId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId, String userId);
  Future<void> deleteAllNotifications(String userId);
  Future<int> getUnreadCount(String userId);
}
