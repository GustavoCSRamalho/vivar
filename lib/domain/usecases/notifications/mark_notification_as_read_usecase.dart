// domain/usecases/notifications/mark_notification_as_read_usecase.dart

import '../../interface/notification/notifications_repository_protocol.dart';

class MarkNotificationAsReadUseCase {
  final NotificationsRepositoryProtocol _repository;

  MarkNotificationAsReadUseCase(this._repository);

  Future<void> execute(String notificationId, String userId) async {
    if (notificationId.trim().isEmpty) {
      throw Exception('ID da notificação é obrigatório');
    }

    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      await _repository.markAsRead(notificationId, userId);
    } catch (e) {
      print('❌ Erro ao marcar notificação como lida: $e');
      rethrow;
    }
  }
}
