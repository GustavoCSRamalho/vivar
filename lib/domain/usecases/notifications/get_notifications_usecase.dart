// domain/usecases/notifications/get_notifications_usecase.dart

import 'package:vivar/domain/entity/notification_entity.dart';

import '../../interface/notification/notifications_repository_protocol.dart';

class GetNotificationsUseCase {
  final NotificationsRepositoryProtocol _repository;

  GetNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.getNotifications(userId);
    } catch (e) {
      print('❌ Erro ao buscar notificações: $e');
      return [];
    }
  }
}
