// data/repositories/notifications_repository_impl.dart

import 'package:vivar/domain/entity/notification/notification_entity.dart';
import 'package:vivar/domain/interface/notification/notifications_repository_protocol.dart';
import 'package:vivar/screens/notifications/data/datasource/notifications_datasource.dart';

/// Implementação do repositório de notificações
/// Delega operações de dados para o datasource
class NotificationsRepositoryImpl implements NotificationsRepositoryProtocol {
  final NotificationsDatasourceProtocol _datasource;

  NotificationsRepositoryImpl({
    required NotificationsDatasourceProtocol datasource,
  }) : _datasource = datasource;

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) {
    return _datasource.getNotifications(userId);
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByType(
    String userId,
    String type,
  ) {
    return _datasource.getNotificationsByType(userId, type);
  }

  @override
  Future<void> markAsRead(String notificationId, String userId) {
    return _datasource.markAsRead(notificationId, userId);
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _datasource.markAllAsRead(userId);
  }

  @override
  Future<void> deleteNotification(String notificationId, String userId) {
    return _datasource.deleteNotification(notificationId, userId);
  }

  @override
  Future<void> deleteAllNotifications(String userId) {
    return _datasource.deleteAllNotifications(userId);
  }

  @override
  Future<int> getUnreadCount(String userId) {
    return _datasource.getUnreadCount(userId);
  }

  /// Método auxiliar para criar notificações de exemplo
  Future<void> createSampleNotifications(String userId) {
    return _datasource.createSampleNotifications(userId);
  }
}
