// domain/usecases/challenges/get_active_challenges_usecase.dart

import '../../entities/challenge_entity.dart';
import '../../repositories/challenges_repository_protocol.dart';

class GetActiveChallengesUseCase {
  final ChallengesRepositoryProtocol _repository;

  GetActiveChallengesUseCase(this._repository);

  Future<List<ChallengeEntity>> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.getActiveChallenges(userId);
    } catch (e) {
      print('❌ Erro ao buscar desafios ativos: $e');
      return [];
    }
  }
}
