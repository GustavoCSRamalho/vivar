// domain/usecases/challenges/get_completed_challenges_usecase.dart

import '../../entities/challenge_entity.dart';
import '../../repositories/challenges_repository_protocol.dart';

class GetCompletedChallengesUseCase {
  final ChallengesRepositoryProtocol _repository;

  GetCompletedChallengesUseCase(this._repository);

  Future<List<ChallengeEntity>> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.getCompletedChallenges(userId);
    } catch (e) {
      print('❌ Erro ao buscar desafios concluídos: $e');
      return [];
    }
  }
}
