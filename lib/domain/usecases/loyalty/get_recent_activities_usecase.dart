// domain/usecases/loyalty/get_recent_activities_usecase.dart

import '../../entity/activity_entity.dart';
import '../../interface/loyalty/loyalty_repository_protocol.dart';

class GetRecentActivitiesUseCase {
  final LoyaltyRepositoryProtocol _repository;

  GetRecentActivitiesUseCase(this._repository);

  Future<List<ActivityEntity>> execute(String userId, {int limit = 10}) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    if (limit <= 0) {
      throw Exception('Limite deve ser maior que zero');
    }

    try {
      return await _repository.getRecentActivities(userId, limit: limit);
    } catch (e) {
      print('❌ Erro ao buscar atividades: $e');
      return [];
    }
  }
}
