// domain/usecases/notification/get_notifications_usecase.dart

import '../../entity/notification_entity.dart';
import '../../interface/notification/notification_repository_protocol.dart';

/// Use Case: Obter notificações
///
/// Responsabilidade: Buscar notificações do usuário
class GetNotificationsUseCase {
  final NotificationRepositoryProtocol _notificationRepository;

  GetNotificationsUseCase(this._notificationRepository);

  /// Executa o caso de uso
  ///
  /// [userId]: ID do usuário
  ///
  /// Retorna lista de notificações
  Future<List<NotificationEntity>> execute(String userId) async {
    try {
      return await _notificationRepository.getUserNotifications(userId);
    } catch (e) {
      print('❌ Erro ao buscar notificações: $e');
      return [];
    }
  }
}
