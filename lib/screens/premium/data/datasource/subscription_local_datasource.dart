import 'package:sqflite/sqflite.dart';
import '../../../../../packages/database_module/lib/src/database_helper.dart';
import 'package:vivar/domain/entity/subscription/subscription_plan_entity.dart';
import 'package:vivar/domain/entity/user/user_subscription_entity.dart';

abstract class SubscriptionLocalDataSourceProtocol {
  Future<List<SubscriptionPlanEntity>> getAvailablePlans();
  Future<UserSubscriptionEntity?> getUserSubscription(String userId);
  Future<void> subscribeToPlan(String userId, String planId, bool isYearly);
  Future<void> cancelSubscription(String userId);
}

class SubscriptionLocalDataSource
    implements SubscriptionLocalDataSourceProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _subscriptionTableName = 'subscriptions';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<SubscriptionPlanEntity>> getAvailablePlans() async {
    return [
      SubscriptionPlanEntity(
        id: 'plus',
        name: 'Vivar Plus',
        description: 'Acesso completo a todos os recursos premium',
        monthlyPrice: 19.90,
        yearlyPrice: 179.90,
        isPopular: true,
        badge: 'MAIS POPULAR',
        features: [
          'Descontos exclusivos em todos os parceiros',
          'Acesso a lugares premium',
          'Check-ins ilimitados',
          'Sem anúncios',
          'Badges exclusivos',
          'Prioridade no suporte',
          'Eventos VIP',
          'Cashback em compras',
        ],
      ),
      SubscriptionPlanEntity(
        id: 'premium',
        name: 'Vivar Premium',
        description: 'Experiência VIP completa',
        monthlyPrice: 39.90,
        yearlyPrice: 359.90,
        isPopular: false,
        badge: 'VIP',
        features: [
          'Tudo do Plus +',
          'Descontos de até 50%',
          'Concierge pessoal',
          'Reservas prioritárias',
          'Acesso antecipado a novos lugares',
          'Benefícios em viagens',
          'Programa de pontos 2x',
          'Convites para eventos exclusivos',
        ],
      ),
    ];
  }

  @override
  Future<UserSubscriptionEntity?> getUserSubscription(String userId) async {
    final db = await _database;

    final result = await db.query(
      _subscriptionTableName,
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final map = result.first;

    return UserSubscriptionEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      planId: map['plan_id'] as String,
      status: map['status'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      isActive: (map['is_active'] as int) == 1,
    );
  }

  @override
  Future<void> subscribeToPlan(
    String userId,
    String planId,
    bool isYearly,
  ) async {
    final db = await _database;

    // Remove a assinatura anterior
    await db.delete(
      _subscriptionTableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    final now = DateTime.now();
    final endDate = isYearly
        ? now.add(const Duration(days: 365))
        : now.add(const Duration(days: 30));

    await db.insert(_subscriptionTableName, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'plan_id': planId,
      'status': 'active',
      'start_date': now.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': 1,
      'created_at': now.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    await db.update(
      'users',
      {'plan_type': 'premium'},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> cancelSubscription(String userId) async {
    final db = await _database;

    await db.update(
      _subscriptionTableName,
      {
        'status': 'cancelled',
        'is_active': 0,
        'end_date': DateTime.now().toIso8601String(),
      },
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
    );

    await db.update(
      'users',
      {'plan_type': 'free'},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
