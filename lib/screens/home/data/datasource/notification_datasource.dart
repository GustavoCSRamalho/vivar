// data/datasources/notification/notification_datasource_impl.dart

// data/datasources/notification/notification_datasource_protocol.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/models/notification_model.dart';

/// Contrato abstrato para datasource de notificações
/// Define os métodos que devem ser implementados para gerenciar dados de notificações
abstract class NotificationDatasourceProtocol {
  /// Busca todas as notificações de um usuário
  ///
  /// [userId] - ID do usuário
  /// Retorna lista de [NotificationModel] ordenadas por data (mais recentes primeiro)
  Future<List<NotificationModel>> getUserNotifications(String userId);

  /// Busca notificações não lidas de um usuário
  ///
  /// [userId] - ID do usuário
  /// Retorna lista de [NotificationModel] não lidas
  Future<List<NotificationModel>> getUnreadNotifications(String userId);

  /// Conta quantas notificações não lidas o usuário possui
  ///
  /// [userId] - ID do usuário
  /// Retorna número de notificações não lidas
  Future<int> getUnreadCount(String userId);

  /// Marca uma notificação como lida
  ///
  /// [notificationId] - ID da notificação
  Future<void> markAsRead(String notificationId);

  /// Marca todas as notificações de um usuário como lidas
  ///
  /// [userId] - ID do usuário
  Future<void> markAllAsRead(String userId);

  /// Adiciona uma nova notificação
  ///
  /// [notification] - Modelo da notificação a ser adicionada
  Future<void> addNotification(NotificationModel notification);

  /// Deleta notificações antigas (mais de 30 dias)
  ///
  /// [userId] - ID do usuário
  Future<void> deleteOldNotifications(String userId);
}

/// Implementação do datasource de notificações
/// Contém TODA a lógica de acesso ao banco de dados SQLite
/// Gerencia operações de leitura, atualização e limpeza de notificações
class NotificationDatasource implements NotificationDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'notifications';
  static const int _notificationRetentionDays = 30;

  NotificationDatasource({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar notificações do usuário: $e');
      return [];
    }
  }

  @override
  Future<List<NotificationModel>> getUnreadNotifications(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'user_id = ? AND is_read = 0',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      return _mapListToModels(maps);
    } catch (e) {
      print('❌ Erro ao buscar notificações não lidas: $e');
      return [];
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    try {
      final db = await _database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_tableName WHERE user_id = ? AND is_read = 0',
        [userId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('❌ Erro ao contar notificações não lidas: $e');
      return 0;
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      final db = await _database;
      await db.update(
        _tableName,
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      print('❌ Erro ao marcar notificação como lida: $e');
      rethrow;
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final db = await _database;
      await db.update(
        _tableName,
        {'is_read': 1},
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print('❌ Erro ao marcar todas as notificações como lidas: $e');
      rethrow;
    }
  }

  @override
  Future<void> addNotification(NotificationModel notification) async {
    try {
      final db = await _database;
      await db.insert(
        _tableName,
        notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Erro ao adicionar notificação: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteOldNotifications(String userId) async {
    try {
      final db = await _database;
      final cutoffDate = _calculateCutoffDate();

      await db.delete(
        _tableName,
        where: 'user_id = ? AND created_at < ?',
        whereArgs: [userId, cutoffDate],
      );
    } catch (e) {
      print('❌ Erro ao deletar notificações antigas: $e');
      rethrow;
    }
  }

  /// Calcula a data de corte para limpeza de notificações antigas
  String _calculateCutoffDate() {
    return DateTime.now()
        .subtract(Duration(days: _notificationRetentionDays))
        .toIso8601String();
  }

  /// Converte lista de Maps para lista de NotificationModel
  List<NotificationModel> _mapListToModels(List<Map<String, dynamic>> maps) {
    return maps.map((map) => NotificationModel.fromMap(map)).toList();
  }
}
