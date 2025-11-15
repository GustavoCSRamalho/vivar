// core/repositories/challenge_repository.dart
import '../database/database_helper.dart';
import '../../models/challenge_model.dart';
import 'base_repository.dart';

// core/repositories/protocols/challenge_protocols.dart

// Arquivo: user_challenge_reader_protocol.dart
/// Protocolo para leitura de desafios do usuário
abstract class UserChallengeReaderProtocol {
  /// Retorna os desafios ativos de um usuário
  Future<List<ChallengeModel>> getActiveChallenges(String userId);

  /// Retorna os desafios completados de um usuário
  Future<List<ChallengeModel>> getCompletedChallenges(String userId);

  /// Retorna desafios por tipo específico
  Future<List<ChallengeModel>> getChallengesByType(String userId, String type);
}

// Arquivo: global_challenge_reader_protocol.dart
/// Protocolo para leitura de desafios globais
abstract class GlobalChallengeReaderProtocol {
  /// Retorna os desafios globais (disponíveis para todos)
  Future<List<ChallengeModel>> getGlobalChallenges();
}

// Arquivo: challenge_progress_manager_protocol.dart
/// Protocolo para gerenciamento de progresso de desafios
abstract class ChallengeProgressManagerProtocol {
  /// Incrementa o progresso de um desafio
  Future<void> incrementProgress(String challengeId, int amount);

  /// Marca um desafio como completado
  Future<void> completeChallenge(String challengeId);
}

// ============================================
// IMPLEMENTAÇÃO NO REPOSITORY
// ============================================

class ChallengeRepository extends BaseRepository<ChallengeModel>
    implements
        UserChallengeReaderProtocol,
        GlobalChallengeReaderProtocol,
        ChallengeProgressManagerProtocol {
  @override
  String get tableName => 'challenges';

  @override
  ChallengeModel fromMap(Map<String, dynamic> map) =>
      ChallengeModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(ChallengeModel model) => model.toMap();

  // Desafios ativos do usuário
  @override
  Future<List<ChallengeModel>> getActiveChallenges(String userId) async {
    return await getWhere(
      'user_id = ? AND is_active = 1 AND is_completed = 0',
      [userId],
    );
  }

  // Desafios completados
  @override
  Future<List<ChallengeModel>> getCompletedChallenges(String userId) async {
    return await getWhere('user_id = ? AND is_completed = 1', [userId]);
  }

  // Desafios globais (sem user_id)
  @override
  Future<List<ChallengeModel>> getGlobalChallenges() async {
    return await getWhere('user_id IS NULL AND is_active = 1', []);
  }

  // Incrementar progresso
  @override
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
  @override
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
  @override
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
