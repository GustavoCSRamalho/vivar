// domain/repositories/notification_repository_protocol.dart

import '../entities/notification_entity.dart';

/// Protocolo (interface) para operações de Notification
abstract class NotificationRepositoryProtocol {
  /// Retorna todas as notificações de um usuário
  Future<List<NotificationEntity>> getUserNotifications(String userId);

  /// Retorna apenas notificações não lidas
  Future<List<NotificationEntity>> getUnreadNotifications(String userId);

  /// Retorna a quantidade de notificações não lidas
  Future<int> getUnreadCount(String userId);

  /// Marca uma notificação como lida
  Future<void> markAsRead(String notificationId);

  /// Marca todas as notificações como lidas
  Future<void> markAllAsRead(String userId);

  /// Adiciona uma nova notificação
  Future<void> addNotification(NotificationEntity notification);

  /// Deleta notificações antigas
  Future<void> deleteOldNotifications(String userId);
}
