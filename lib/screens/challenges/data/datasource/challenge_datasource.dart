// data/datasources/challenge/challenge_datasource_impl.dart

// data/datasources/challenge/challenge_datasource_protocol.dart

import 'package:sqflite/sqflite.dart';
import '../../../../../packages/database_module/lib/src/database_helper.dart';
import 'package:vivar/domain/entity/challenge/challenge_entity.dart';

/// Contrato abstrato para datasource de desafios
abstract class ChallengeDatasourceProtocol {
  /// Busca todos os desafios de um usuário
  Future<List<ChallengeEntity>> getChallenges(String userId);

  /// Busca desafios ativos de um usuário
  Future<List<ChallengeEntity>> getActiveChallenges(String userId);

  /// Busca desafios completados de um usuário
  Future<List<ChallengeEntity>> getCompletedChallenges(String userId);

  /// Atualiza o progresso de um desafio
  Future<void> updateChallengeProgress(
    String userId,
    String challengeId,
    int newCount,
  );

  /// Marca um desafio como completo
  Future<void> completeChallenge(String userId, String challengeId);

  /// Cria desafios de exemplo (seed data)
  Future<void> createSampleChallenges();
}

/// Implementação do datasource de desafios
/// Contém TODA a lógica de acesso ao banco de dados SQLite
/// Gerencia tabelas 'challenges' e 'user_challenges'
class ChallengeDatasourceImpl implements ChallengeDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'challenges';
  static const String _userChallengesTableName = 'user_challenges';

  ChallengeDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<ChallengeEntity>> getChallenges(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT c.*, uc.current_count, uc.is_completed, uc.completed_at
        FROM $_tableName c
        LEFT JOIN $_userChallengesTableName uc 
          ON c.id = uc.challenge_id AND uc.user_id = ?
        ORDER BY c.start_date DESC
      ''',
        [userId],
      );
      return _mapListToEntities(maps);
    } catch (e) {
      print('❌ Erro ao buscar desafios: $e');
      return [];
    }
  }

  @override
  Future<List<ChallengeEntity>> getActiveChallenges(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT c.*, uc.current_count, uc.is_completed, uc.completed_at
        FROM $_tableName c
        LEFT JOIN $_userChallengesTableName uc 
          ON c.id = uc.challenge_id AND uc.user_id = ?
        WHERE (uc.is_completed IS NULL OR uc.is_completed = 0)
          AND c.end_date > ?
        ORDER BY c.end_date ASC
      ''',
        [userId, DateTime.now().toIso8601String()],
      );
      return _mapListToEntities(maps);
    } catch (e) {
      print('❌ Erro ao buscar desafios ativos: $e');
      return [];
    }
  }

  @override
  Future<List<ChallengeEntity>> getCompletedChallenges(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        '''
        SELECT c.*, uc.current_count, uc.is_completed, uc.completed_at
        FROM $_tableName c
        INNER JOIN $_userChallengesTableName uc 
          ON c.id = uc.challenge_id AND uc.user_id = ?
        WHERE uc.is_completed = 1
        ORDER BY uc.completed_at DESC
      ''',
        [userId],
      );
      return _mapListToEntities(maps);
    } catch (e) {
      print('❌ Erro ao buscar desafios completados: $e');
      return [];
    }
  }

  @override
  Future<void> updateChallengeProgress(
    String userId,
    String challengeId,
    int newCount,
  ) async {
    try {
      final db = await _database;
      await db.insert(_userChallengesTableName, {
        'user_id': userId,
        'challenge_id': challengeId,
        'current_count': newCount,
        'is_completed': 0,
        'updated_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('❌ Erro ao atualizar progresso do desafio: $e');
      rethrow;
    }
  }

  @override
  Future<void> completeChallenge(String userId, String challengeId) async {
    try {
      final db = await _database;
      await db.update(
        _userChallengesTableName,
        {
          'is_completed': 1,
          'completed_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'user_id = ? AND challenge_id = ?',
        whereArgs: [userId, challengeId],
      );
    } catch (e) {
      print('❌ Erro ao completar desafio: $e');
      rethrow;
    }
  }

  @override
  Future<void> createSampleChallenges() async {
    try {
      final db = await _database;
      final now = DateTime.now();

      final challenges = _buildSampleChallenges(now);

      for (var challenge in challenges) {
        await db.insert(
          _tableName,
          challenge,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print('❌ Erro ao criar desafios de exemplo: $e');
      rethrow;
    }
  }

  /// Converte lista de Maps para lista de ChallengeEntity
  List<ChallengeEntity> _mapListToEntities(List<Map<String, dynamic>> maps) {
    return maps.map(_mapToEntity).toList();
  }

  /// Converte um Map para ChallengeEntity
  ChallengeEntity _mapToEntity(Map<String, dynamic> map) {
    return ChallengeEntity(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      challengeType: map['challenge_type'] as String,
      targetCount: map['target_count'] as int,
      currentCount: map['current_count'] as int? ?? 0,
      rewardPoints: map['reward_points'] as int,
      rewardBadge: map['reward_badge'] as String?,
      rewardDiscount: map['reward_discount'] as String?,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
    );
  }

  /// Constrói desafios de exemplo para popular o banco
  List<Map<String, dynamic>> _buildSampleChallenges(DateTime now) {
    return [
      {
        'id': 'challenge_1',
        'title': 'Explorador Iniciante',
        'description': 'Visite 5 lugares diferentes',
        'challenge_type': 'checkin',
        'target_count': 5,
        'reward_points': 250,
        'reward_badge': 'Explorador',
        'reward_discount': '10% OFF',
        'start_date': now.subtract(Duration(days: 7)).toIso8601String(),
        'end_date': now.add(Duration(days: 23)).toIso8601String(),
      },
      {
        'id': 'challenge_2',
        'title': 'Desbravador de Cafés',
        'description': 'Faça check-in em 3 cafés diferentes',
        'challenge_type': 'explore',
        'target_count': 3,
        'reward_points': 150,
        'reward_badge': 'Café Lover',
        'reward_discount': '15% OFF em cafés',
        'start_date': now.subtract(Duration(days: 5)).toIso8601String(),
        'end_date': now.add(Duration(days: 25)).toIso8601String(),
      },
      {
        'id': 'challenge_3',
        'title': 'Social Butterfly',
        'description': 'Convide 5 amigos para o app',
        'challenge_type': 'social',
        'target_count': 5,
        'reward_points': 500,
        'reward_badge': 'Influencer',
        'reward_discount': '20% OFF',
        'start_date': now.subtract(Duration(days: 3)).toIso8601String(),
        'end_date': now.add(Duration(days: 27)).toIso8601String(),
      },
    ];
  }
}
