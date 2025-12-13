// data/datasources/notification/notifications_datasource.dart

import 'package:sqflite/sqflite.dart';
import '../../../../../packages/database_module/lib/src/database_helper.dart';
import '../../../../../packages/home_module/lib/src/domain/entity/notification_entity.dart';
import 'dart:convert';

/// Contrato abstrato para datasource de notificações
abstract class NotificationsDatasourceProtocol {
  /// Busca todas as notificações de um usuário
  Future<List<NotificationEntity>> getNotifications(String userId);

  /// Busca notificações por tipo
  Future<List<NotificationEntity>> getNotificationsByType(
    String userId,
    String type,
  );

  /// Marca uma notificação como lida
  Future<void> markAsRead(String notificationId, String userId);

  /// Marca todas as notificações como lidas
  Future<void> markAllAsRead(String userId);

  /// Deleta uma notificação
  Future<void> deleteNotification(String notificationId, String userId);

  /// Deleta todas as notificações
  Future<void> deleteAllNotifications(String userId);

  /// Conta notificações não lidas
  Future<int> getUnreadCount(String userId);

  /// Cria notificações de exemplo
  Future<void> createSampleNotifications(String userId);
}

/// Implementação do datasource de notificações
/// Contém TODA a lógica de acesso ao banco de dados SQLite
class NotificationsDatasource implements NotificationsDatasourceProtocol {
  final DatabaseHelper _dbHelper;

  static const String _tableName = 'notifications';

  NotificationsDatasource({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return maps.map(_mapToEntity).toList();
    } catch (e) {
      print('❌ Erro ao buscar notificações: $e');
      return [];
    }
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByType(
    String userId,
    String type,
  ) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'user_id = ? AND type = ?',
        whereArgs: [userId, type],
        orderBy: 'created_at DESC',
      );

      return maps.map(_mapToEntity).toList();
    } catch (e) {
      print('❌ Erro ao buscar notificações por tipo: $e');
      return [];
    }
  }

  @override
  Future<void> markAsRead(String notificationId, String userId) async {
    try {
      final db = await _database;
      await db.update(
        _tableName,
        {'is_read': 1},
        where: 'id = ? AND user_id = ?',
        whereArgs: [notificationId, userId],
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
      print('❌ Erro ao marcar todas notificações como lidas: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteNotification(String notificationId, String userId) async {
    try {
      final db = await _database;
      await db.delete(
        _tableName,
        where: 'id = ? AND user_id = ?',
        whereArgs: [notificationId, userId],
      );
    } catch (e) {
      print('❌ Erro ao deletar notificação: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final db = await _database;
      await db.delete(_tableName, where: 'user_id = ?', whereArgs: [userId]);
    } catch (e) {
      print('❌ Erro ao deletar todas notificações: $e');
      rethrow;
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
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      print('❌ Erro ao contar notificações não lidas: $e');
      return 0;
    }
  }

  @override
  Future<void> createSampleNotifications(String userId) async {
    try {
      final db = await _database;
      final notifications = _buildSampleNotifications(userId);

      for (var notification in notifications) {
        await db.insert(
          _tableName,
          notification,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      print('❌ Erro ao criar notificações de exemplo: $e');
      rethrow;
    }
  }

  /// Converte Map do banco para NotificationEntity
  NotificationEntity _mapToEntity(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      isRead: (map['is_read'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      data: map['data'] != null ? jsonDecode(map['data'] as String) : null,
    );
  }

  /// Constrói notificações de exemplo
  List<Map<String, dynamic>> _buildSampleNotifications(String userId) {
    final now = DateTime.now();

    return [
      {
        'id': '1',
        'user_id': userId,
        'type': 'offer',
        'title': '🎉 Oferta especial!',
        'message': 'Café Raiz está com 20% de desconto hoje!',
        'is_read': 0,
        'created_at': now.subtract(Duration(hours: 1)).toIso8601String(),
        'data': jsonEncode({'placeId': 'place_1'}),
      },
      {
        'id': '2',
        'user_id': userId,
        'type': 'checkin',
        'title': 'Check-in realizado!',
        'message': 'Você ganhou 50 pontos no Café Raiz',
        'is_read': 1,
        'created_at': now.subtract(Duration(hours: 3)).toIso8601String(),
        'data': null,
      },
      {
        'id': '3',
        'user_id': userId,
        'type': 'badge',
        'title': '🏆 Novo badge conquistado!',
        'message': 'Você ganhou o badge "Café Explorer"',
        'is_read': 0,
        'created_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'data': jsonEncode({'badgeId': 'badge_1'}),
      },
      {
        'id': '4',
        'user_id': userId,
        'type': 'social',
        'title': 'Novo seguidor',
        'message': 'Maria Silva começou a seguir você',
        'is_read': 1,
        'created_at': now.subtract(Duration(days: 2)).toIso8601String(),
        'data': jsonEncode({'userId': 'user_2'}),
      },
      {
        'id': '5',
        'user_id': userId,
        'type': 'system',
        'title': 'Atualização disponível',
        'message': 'Nova versão do app disponível com melhorias',
        'is_read': 0,
        'created_at': now.subtract(Duration(days: 3)).toIso8601String(),
        'data': null,
      },
    ];
  }
}
