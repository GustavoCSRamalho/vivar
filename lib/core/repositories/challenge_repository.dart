// core/repositories/challenge_repository.dart
import '../database/database_helper.dart';
import '../../models/challenge_model.dart';
import 'base_repository.dart';

class ChallengeRepository extends BaseRepository<ChallengeModel> {
  @override
  String get tableName => 'challenges';

  @override
  ChallengeModel fromMap(Map<String, dynamic> map) =>
      ChallengeModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(ChallengeModel model) => model.toMap();

  // Desafios ativos do usuário
  Future<List<ChallengeModel>> getActiveChallenges(String userId) async {
    return await getWhere(
      'user_id = ? AND is_active = 1 AND is_completed = 0',
      [userId],
    );
  }

  // Desafios completados
  Future<List<ChallengeModel>> getCompletedChallenges(String userId) async {
    return await getWhere('user_id = ? AND is_completed = 1', [userId]);
  }

  // Desafios globais (sem user_id)
  Future<List<ChallengeModel>> getGlobalChallenges() async {
    return await getWhere('user_id IS NULL AND is_active = 1', []);
  }

  // Incrementar progresso
  Future<void> incrementProgress(String challengeId, int amount) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE $tableName SET current_count = current_count + ?, updated_at = ? WHERE id = ?',
      [amount, DateTime.now().toIso8601String(), challengeId],
    );

    // Verificar se completou
    final challenge = await getById(challengeId);
    if (challenge != null && challenge.currentCount >= challenge.targetCount) {
      await completeChallenge(challengeId);
    }
  }

  // Completar desafio
  Future<void> completeChallenge(String challengeId) async {
    final db = await database;
    await db.update(
      tableName,
      {
        'is_completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [challengeId],
    );
  }

  // Desafios por tipo
  Future<List<ChallengeModel>> getChallengesByType(
    String userId,
    String type,
  ) async {
    return await getWhere(
      'user_id = ? AND challenge_type = ? AND is_active = 1',
      [userId, type],
    );
  }
}
