// data/datasources/loyalty/loyalty_datasource.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/domain/entity/acitivty/activity_entity.dart';
import 'package:vivar/domain/entity/benefit/benefit_entity.dart';
import 'package:vivar/domain/entity/loyalt/loyalty_card_entity.dart';

/// Contrato abstrato para datasource de fidelidade
abstract class LoyaltyDatasourceProtocol {
  /// Busca dados do cartão de fidelidade do usuário
  Future<LoyaltyCardEntity?> getLoyaltyCard(String userId);

  /// Busca benefícios ativos
  Future<List<BenefitEntity>> getActiveBenefits(String userId);

  /// Busca atividades recentes do usuário
  Future<List<ActivityEntity>> getRecentActivities(
    String userId, {
    int limit = 10,
  });

  /// Registra resgate de benefício
  Future<void> redeemBenefit(String userId, String benefitId);

  /// Atualiza pontos do usuário
  Future<void> updateUserPoints(String userId, int pointsChange);

  /// Gera código único para QR Code
  String generateQRCode(String userId);
}

/// Implementação do datasource de fidelidade
/// Contém TODA a lógica de acesso ao banco de dados SQLite
class LoyaltyDatasourceImpl implements LoyaltyDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _userTableName = 'users';
  static const String _benefitsTableName = 'benefits';
  static const String _activitiesTableName = 'activities';
  static const int _benefitRedemptionCost = 200;

  LoyaltyDatasourceImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<LoyaltyCardEntity?> getLoyaltyCard(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _userTableName,
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (maps.isEmpty) return null;

      final user = maps.first;
      return LoyaltyCardEntity(
        userId: user['id'] as String,
        userName: user['name'] as String,
        userEmail: user['email'] as String,
        cardNumber: _generateCardNumber(user['id'] as String),
        planType: user['plan_type'] as String? ?? 'free',
        points: user['points'] as int? ?? 0,
        businessesVisited: user['businesses_visited'] as int? ?? 0,
        activeCoupons: 8, // Mock data - poderia vir de outra tabela
        badgesCount: user['badges_count'] as int? ?? 0,
        streakDays: user['streak_days'] as int? ?? 0,
        memberSince: DateTime.parse(user['created_at'] as String),
      );
    } catch (e) {
      print('❌ Erro ao buscar cartão de fidelidade: $e');
      return null;
    }
  }

  @override
  Future<List<BenefitEntity>> getActiveBenefits(String userId) async {
    // Mock data - em produção viria do banco
    // TODO: Implementar busca real no banco quando a tabela estiver pronta
    return _getMockBenefits();
  }

  @override
  Future<List<ActivityEntity>> getRecentActivities(
    String userId, {
    int limit = 10,
  }) async {
    // Mock data - em produção viria do banco
    // TODO: Implementar busca real no banco quando a tabela estiver pronta
    return _getMockActivities(userId, limit);
  }

  @override
  Future<void> redeemBenefit(String userId, String benefitId) async {
    try {
      final db = await _database;

      // Registrar resgate na tabela de atividades
      await db.insert(_activitiesTableName, {
        'id': _generateActivityId(),
        'user_id': userId,
        'type': 'coupon',
        'title': 'Cupom resgatado',
        'subtitle': 'Benefício resgatado',
        'points_change': -_benefitRedemptionCost,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Atualizar pontos do usuário
      await updateUserPoints(userId, -_benefitRedemptionCost);
    } catch (e) {
      print('❌ Erro ao resgatar benefício: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserPoints(String userId, int pointsChange) async {
    try {
      final db = await _database;

      final user = await db.query(
        _userTableName,
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (user.isEmpty) {
        throw Exception('Usuário não encontrado');
      }

      final currentPoints = user.first['points'] as int? ?? 0;
      final newPoints = currentPoints + pointsChange;

      await db.update(
        _userTableName,
        {'points': newPoints},
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('❌ Erro ao atualizar pontos do usuário: $e');
      rethrow;
    }
  }

  @override
  String generateQRCode(String userId) {
    return 'VIZ-${userId.substring(0, 5).toUpperCase()}';
  }

  /// Gera número do cartão baseado no ID do usuário
  String _generateCardNumber(String userId) {
    return userId.substring(0, 8);
  }

  /// Gera ID único para atividade
  String _generateActivityId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Retorna benefícios mock
  List<BenefitEntity> _getMockBenefits() {
    return [
      BenefitEntity(
        id: '1',
        merchantId: 'merchant_1',
        merchantName: 'Café Raiz',
        title: '15% OFF',
        description: 'Válido em todo o cardápio',
        discountType: 'percentage',
        discountValue: 15.0,
        validUntil: DateTime(2025, 12, 31),
        isActive: true,
        pointsCost: 100,
      ),
      BenefitEntity(
        id: '2',
        merchantId: 'merchant_2',
        merchantName: 'Bistrô Central',
        title: '20% OFF',
        description: 'Desconto em pratos principais',
        discountType: 'percentage',
        discountValue: 20.0,
        validUntil: DateTime(2025, 11, 30),
        isActive: true,
        pointsCost: 150,
      ),
      BenefitEntity(
        id: '3',
        merchantId: 'merchant_3',
        merchantName: 'Padaria Aurora',
        title: 'Café Grátis',
        description: 'Na compra de qualquer pão',
        discountType: 'freeItem',
        discountValue: 0.0,
        validUntil: DateTime(2025, 10, 31),
        isActive: true,
        pointsCost: 50,
      ),
    ];
  }

  /// Retorna atividades mock
  List<ActivityEntity> _getMockActivities(String userId, int limit) {
    final now = DateTime.now();
    return [
      ActivityEntity(
        id: '1',
        userId: userId,
        type: 'checkin',
        title: 'Check-in',
        subtitle: 'Café Raiz',
        pointsChange: 50,
        timestamp: now.subtract(Duration(hours: 2)),
      ),
      ActivityEntity(
        id: '2',
        userId: userId,
        type: 'coupon',
        title: 'Cupom resgatado',
        subtitle: 'Bistrô Central',
        pointsChange: -200,
        timestamp: now.subtract(Duration(days: 1)),
      ),
      ActivityEntity(
        id: '3',
        userId: userId,
        type: 'checkin',
        title: 'Check-in',
        subtitle: 'Padaria Aurora',
        pointsChange: 50,
        timestamp: now.subtract(Duration(days: 3)),
      ),
      ActivityEntity(
        id: '4',
        userId: userId,
        type: 'badge',
        title: 'Badge conquistado',
        subtitle: 'Café Explorer',
        pointsChange: 500,
        timestamp: now.subtract(Duration(days: 5)),
      ),
      ActivityEntity(
        id: '5',
        userId: userId,
        type: 'checkin',
        title: 'Check-in',
        subtitle: 'Bar do João',
        pointsChange: 50,
        timestamp: now.subtract(Duration(days: 7)),
      ),
    ].take(limit).toList();
  }
}
