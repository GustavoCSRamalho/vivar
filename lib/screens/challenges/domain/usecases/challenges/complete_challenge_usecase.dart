// domain/usecases/challenges/complete_challenge_usecase.dart

import '../../repositories/challenges_repository_protocol.dart';

class CompleteChallengeUseCase {
  final ChallengesRepositoryProtocol _repository;

  CompleteChallengeUseCase(this._repository);

  Future<void> execute(String userId, String challengeId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    if (challengeId.trim().isEmpty) {
      throw Exception('ID do desafio é obrigatório');
    }

    try {
      await _repository.completeChallenge(userId, challengeId);
    } catch (e) {
      print('❌ Erro ao completar desafio: $e');
      rethrow;
    }
  }
}
