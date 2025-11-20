// domain/usecases/challenges/get_active_challenges_usecase.dart

import '../../entity/challenge/challenge_entity.dart';
import '../../interface/challenges/challenges_repository_protocol.dart';

class GetActiveChallengesUseCase {
  final GetActiveChallengesProtocol _repository;

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
