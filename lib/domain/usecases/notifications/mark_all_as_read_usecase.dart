// domain/usecases/notifications/mark_all_as_read_usecase.dart

import '../../interface/notification/notifications_repository_protocol.dart';

class MarkAllAsReadUseCase {
  final NotificationsRepositoryProtocol _repository;

  MarkAllAsReadUseCase(this._repository);

  Future<void> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      await _repository.markAllAsRead(userId);
    } catch (e) {
      print('❌ Erro ao marcar todas como lidas: $e');
      rethrow;
    }
  }
}
