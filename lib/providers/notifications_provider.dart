// providers/notifications_provider.dart
import 'package:flutter/foundation.dart';
import 'package:vivar/screens/home/data/models/notification_model.dart';
import '../core/repositories/notification_repository.dart';

class NotificationsProvider with ChangeNotifier {
  final NotificationRepository _notificationRepo = NotificationRepository();

  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUnread => _unreadCount > 0;

  // Carregar notificações
  Future<void> loadNotifications(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _notifications = await _notificationRepo.getUserNotifications(userId);
      _unreadCount = await _notificationRepo.getUnreadCount(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adicionar notificação
  Future<void> addNotification(NotificationModel notification) async {
    try {
      await _notificationRepo.insert(notification);
      await loadNotifications(notification.userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Marcar como lida
  Future<void> markAsRead(String notificationId, String userId) async {
    try {
      await _notificationRepo.markAsRead(notificationId);
      await loadNotifications(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Marcar todas como lidas
  Future<void> markAllAsRead(String userId) async {
    try {
      await _notificationRepo.markAllAsRead(userId);
      await loadNotifications(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Deletar notificações antigas
  Future<void> deleteOldNotifications(String userId) async {
    try {
      await _notificationRepo.deleteOldNotifications(userId);
      await loadNotifications(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
