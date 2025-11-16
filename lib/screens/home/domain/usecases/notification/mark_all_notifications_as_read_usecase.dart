// domain/usecases/notification/mark_all_notifications_as_read_usecase.dart

import '../../repositories/notification_repository_protocol.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepositoryProtocol _notificationRepository;

  MarkAllNotificationsAsReadUseCase(this._notificationRepository);

  Future<void> execute(String userId) async {
    try {
      if (userId.trim().isEmpty) {
        throw Exception('User ID não pode ser vazio');
      }

      await _notificationRepository.markAllAsRead(userId);
    } catch (e) {
      print('❌ Erro ao marcar todas notificações como lidas: $e');
      rethrow;
    }
  }
}
