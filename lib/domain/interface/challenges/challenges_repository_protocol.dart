// domain/repositories/challenges_repository_protocol.dart

import '../../entity/challenge_entity.dart';

abstract class ChallengesRepositoryProtocol {
  Future<List<ChallengeEntity>> getChallenges(String userId);
  Future<List<ChallengeEntity>> getActiveChallenges(String userId);
  Future<List<ChallengeEntity>> getCompletedChallenges(String userId);
  Future<void> updateChallengeProgress(
    String userId,
    String challengeId,
    int newCount,
  );
  Future<void> completeChallenge(String userId, String challengeId);
}
