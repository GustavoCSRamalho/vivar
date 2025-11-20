// domain/usecases/notifications/get_notifications_by_type_usecase.dart

import '../../entity/notification/notification_entity.dart';
import '../../interface/notification/notifications_repository_protocol.dart';

class GetNotificationsByTypeUseCase {
  final NotificationsRepositoryProtocol _repository;

  GetNotificationsByTypeUseCase(this._repository);

  Future<List<NotificationEntity>> execute(String userId, String type) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    if (type.trim().isEmpty) {
      throw Exception('Tipo de notificação é obrigatório');
    }

    try {
      final result = await _repository.getNotificationsByType(userId, type);
      return result;
    } catch (e) {
      print('❌ Erro ao buscar notificações por tipo: $e');
      return [];
    }
  }
}
