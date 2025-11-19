// data/repositories/loyalty_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/domain/entity/activity_entity.dart';
import 'package:vivar/domain/entity/benefit_entity.dart';
import 'package:vivar/domain/entity/loyalty_card_entity.dart';
import 'package:vivar/domain/interface/loyalty/loyalty_repository_protocol.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _userTableName = 'users';
  final String _benefitsTableName = 'benefits';
  final String _activitiesTableName = 'activities';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<LoyaltyCardEntity?> getLoyaltyCard(String userId) async {
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
      cardNumber: user['id'].toString().substring(0, 8),
      planType: user['plan_type'] as String? ?? 'free',
      points: user['points'] as int? ?? 0,
      placesVisited: user['places_visited'] as int? ?? 0,
      activeCoupons: 8, // Mock data
      badgesCount: user['badges_count'] as int? ?? 0,
      streakDays: user['streak_days'] as int? ?? 0,
      memberSince: DateTime.parse(user['created_at'] as String),
    );
  }

  @override
  Future<List<BenefitEntity>> getActiveBenefits(String userId) async {
    // Mock data - em produção viria do banco
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

  @override
  Future<List<ActivityEntity>> getRecentActivities(
    String userId, {
    int limit = 10,
  }) async {
    // Mock data - em produção viria do banco
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

  @override
  Future<void> redeemBenefit(String userId, String benefitId) async {
    final db = await _database;

    // Registrar resgate
    await db.insert(_activitiesTableName, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'type': 'coupon',
      'title': 'Cupom resgatado',
      'subtitle': 'Benefício resgatado',
      'points_change': -200,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Atualizar pontos do usuário
    final user = await db.query(
      _userTableName,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (user.isNotEmpty) {
      final currentPoints = user.first['points'] as int? ?? 0;
      await db.update(
        _userTableName,
        {'points': currentPoints - 200},
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
  }

  @override
  Future<String> generateQRCode(String userId) async {
    // Gerar código único para o QR Code
    return 'VIZ-${userId.substring(0, 5).toUpperCase()}';
  }
}
