// domain/repositories/challenges_repository_protocol.dart

import '../../entity/challenge/challenge_entity.dart';

/// Busca todos os desafios (ativos + completos)
abstract class GetChallengesProtocol {
  Future<List<ChallengeEntity>> getChallenges(String userId);
}

/// Busca apenas desafios ativos
abstract class GetActiveChallengesProtocol {
  Future<List<ChallengeEntity>> getActiveChallenges(String userId);
}

/// Busca apenas desafios finalizados
abstract class GetCompletedChallengesProtocol {
  Future<List<ChallengeEntity>> getCompletedChallenges(String userId);
}

// ===============================================
// UPDATING PROGRESS
// ===============================================

/// Atualiza progresso (ex: contagem de hábitos)
abstract class UpdateChallengeProgressProtocol {
  Future<void> updateChallengeProgress(
    String userId,
    String challengeId,
    int newCount,
  );
}

// ===============================================
// COMPLETING A CHALLENGE
// ===============================================

/// Marca desafio como concluído
abstract class CompleteChallengeProtocol {
  Future<void> completeChallenge(String userId, String challengeId);
}
