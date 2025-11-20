// presentation/providers/notifications_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/notification/notification_entity.dart';

import '../../../../domain/usecases/notifications/delete_notification_usecase.dart';
import '../../../../domain/usecases/notifications/get_notifications_by_type_usecase.dart';
import '../../../../domain/usecases/notifications/get_notifications_usecase.dart';
import '../../../../domain/usecases/notifications/get_unread_count_usecase.dart';
import '../../../../domain/usecases/notifications/mark_all_as_read_usecase.dart';
import '../../../../domain/usecases/notifications/mark_notification_as_read_usecase.dart';

class NotificationsProvider with ChangeNotifier {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetNotificationsByTypeUseCase _getNotificationsByTypeUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final GetUnreadCountUseCase _getUnreadCountUseCase;

  NotificationsProvider({
    required GetNotificationsUseCase getNotificationsUseCase,
    required GetNotificationsByTypeUseCase getNotificationsByTypeUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required MarkAllAsReadUseCase markAllAsReadUseCase,
    required DeleteNotificationUseCase deleteNotificationUseCase,
    required GetUnreadCountUseCase getUnreadCountUseCase,
  }) : _getNotificationsUseCase = getNotificationsUseCase,
       _getNotificationsByTypeUseCase = getNotificationsByTypeUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       _markAllAsReadUseCase = markAllAsReadUseCase,
       _deleteNotificationUseCase = deleteNotificationUseCase,
       _getUnreadCountUseCase = getUnreadCountUseCase;

  List<NotificationEntity> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<NotificationEntity> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get hasUnread => _unreadCount > 0;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotifications(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _notifications = await _getNotificationsUseCase.execute(userId);
      _unreadCount = await _getUnreadCountUseCase.execute(userId);
      debugPrint('✅ Notificações carregadas: ${_notifications.length}');
    } catch (e) {
      _error = 'Erro ao carregar notificações';
      debugPrint('❌ Erro ao carregar notificações: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<List<NotificationEntity>> getNotificationsByType(
    String userId,
    String type,
  ) async {
    try {
      return await _getNotificationsByTypeUseCase.execute(userId, type);
    } catch (e) {
      debugPrint('❌ Erro ao filtrar notificações: $e');
      return [];
    }
  }

  Future<void> markAsRead(String notificationId, String userId) async {
    try {
      await _markNotificationAsReadUseCase.execute(notificationId, userId);

      // Atualizar localmente
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final notification = _notifications[index];
        if (!notification.isRead) {
          _notifications[index] = NotificationEntity(
            id: notification.id,
            userId: notification.userId,
            type: notification.type,
            title: notification.title,
            message: notification.message,
            isRead: true,
            createdAt: notification.createdAt,
            data: notification.data,
          );
          _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
          notifyListeners();
        }
      }

      debugPrint('✅ Notificação marcada como lida');
    } catch (e) {
      _error = 'Erro ao marcar notificação como lida';
      debugPrint('❌ Erro ao marcar como lida: $e');
    }
  }

  Future<void> markAllAsRead(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      await _markAllAsReadUseCase.execute(userId);

      // Atualizar localmente
      _notifications = _notifications.map((notification) {
        return NotificationEntity(
          id: notification.id,
          userId: notification.userId,
          type: notification.type,
          title: notification.title,
          message: notification.message,
          isRead: true,
          createdAt: notification.createdAt,
          data: notification.data,
        );
      }).toList();
      _unreadCount = 0;

      debugPrint('✅ Todas notificações marcadas como lidas');
    } catch (e) {
      _error = 'Erro ao marcar todas como lidas';
      debugPrint('❌ Erro ao marcar todas: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteNotification(String notificationId, String userId) async {
    try {
      await _deleteNotificationUseCase.execute(notificationId, userId);

      // Remover localmente
      final notification = _notifications.firstWhere(
        (n) => n.id == notificationId,
      );
      _notifications.removeWhere((n) => n.id == notificationId);

      if (!notification.isRead) {
        _unreadCount = (_unreadCount - 1).clamp(0, double.infinity).toInt();
      }

      notifyListeners();
      debugPrint('✅ Notificação deletada');
    } catch (e) {
      _error = 'Erro ao deletar notificação';
      debugPrint('❌ Erro ao deletar: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
