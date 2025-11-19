// domain/usecases/notification/check_unread_notifications_usecase.dart

import '../../interface/notification/notification_repository_protocol.dart';

/// Use Case: Verificar notificações não lidas
///
/// Responsabilidade: Verificar se há notificações não lidas
class CheckUnreadNotificationsUseCase {
  final NotificationRepositoryProtocol _notificationRepository;

  CheckUnreadNotificationsUseCase(this._notificationRepository);

  /// Executa o caso de uso
  ///
  /// [userId]: ID do usuário
  ///
  /// Retorna quantidade de notificações não lidas
  Future<int> execute(String userId) async {
    try {
      return await _notificationRepository.getUnreadCount(userId);
    } catch (e) {
      print('❌ Erro ao verificar notificações não lidas: $e');
      return 0;
    }
  }
}
