// domain/usecases/notifications/get_unread_count_usecase.dart

import '../../interface/notification/notifications_repository_protocol.dart';

class GetUnreadCountUseCase {
  final NotificationsRepositoryProtocol _repository;

  GetUnreadCountUseCase(this._repository);

  Future<int> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.getUnreadCount(userId);
    } catch (e) {
      print('❌ Erro ao buscar contagem de não lidas: $e');
      return 0;
    }
  }
}
