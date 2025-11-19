// data/repositories/notifications_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'dart:convert';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository_protocol.dart';

class NotificationsRepositoryImpl implements NotificationsRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String _tableName = 'notifications';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToEntity(map)).toList();
  }

  @override
  Future<List<NotificationEntity>> getNotificationsByType(
    String userId,
    String type,
  ) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'user_id = ? AND type = ?',
      whereArgs: [userId, type],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToEntity(map)).toList();
  }

  @override
  Future<void> markAsRead(String notificationId, String userId) async {
    final db = await _database;
    await db.update(
      _tableName,
      {'is_read': 1},
      where: 'id = ? AND user_id = ?',
      whereArgs: [notificationId, userId],
    );
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final db = await _database;
    await db.update(
      _tableName,
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> deleteNotification(String notificationId, String userId) async {
    final db = await _database;
    await db.delete(
      _tableName,
      where: 'id = ? AND user_id = ?',
      whereArgs: [notificationId, userId],
    );
  }

  @override
  Future<void> deleteAllNotifications(String userId) async {
    final db = await _database;
    await db.delete(_tableName, where: 'user_id = ?', whereArgs: [userId]);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final db = await _database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return result.first['count'] as int? ?? 0;
  }

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

  // Método auxiliar para criar notificações de exemplo
  Future<void> createSampleNotifications(String userId) async {
    final db = await _database;
    final now = DateTime.now();

    final notifications = [
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

    for (var notification in notifications) {
      await db.insert(
        _tableName,
        notification,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
