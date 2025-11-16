// core/repositories/notification_repository.dart
import '../database/database_helper.dart';
import '../../screens/home/data/models/notification_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

// core/repositories/protocols/notification_protocols.dart

// Arquivo: user_notification_reader_protocol.dart
/// Protocolo para leitura de notificações do usuário
abstract class UserNotificationReaderProtocol {
  /// Retorna todas as notificações de um usuário
  Future<List<NotificationModel>> getUserNotifications(String userId);

  /// Retorna apenas as notificações não lidas
  Future<List<NotificationModel>> getUnreadNotifications(String userId);

  /// Retorna notificações por tipo específico
  Future<List<NotificationModel>> getByType(String userId, String type);
}

// Arquivo: notification_counter_protocol.dart
/// Protocolo para contagem de notificações
abstract class NotificationCounterProtocol {
  /// Retorna a quantidade de notificações não lidas
  Future<int> getUnreadCount(String userId);
}

// Arquivo: notification_manager_protocol.dart
/// Protocolo para gerenciamento de notificações
abstract class NotificationManagerProtocol {
  /// Marca uma notificação específica como lida
  Future<int> markAsRead(String notificationId);

  /// Marca todas as notificações do usuário como lidas
  Future<int> markAllAsRead(String userId);

  /// Deleta notificações antigas (mais de 30 dias)
  Future<int> deleteOldNotifications(String userId);
}

// ============================================
// IMPLEMENTAÇÃO NO REPOSITORY
// ============================================

class NotificationRepository extends BaseRepository<NotificationModel>
    implements
        UserNotificationReaderProtocol,
        NotificationCounterProtocol,
        NotificationManagerProtocol {
  @override
  String get tableName => 'notifications';

  @override
  NotificationModel fromMap(Map<String, dynamic> map) =>
      NotificationModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(NotificationModel model) => model.toMap();

  // Notificações do usuário
  @override
  Future<List<NotificationModel>> getUserNotifications(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => NotificationModel.fromMap(map)).toList();
  }

  // Notificações não lidas
  @override
  Future<List<NotificationModel>> getUnreadNotifications(String userId) async {
    return await getWhere('user_id = ? AND is_read = 0', [userId]);
  }

  // Contagem de não lidas
  @override
  Future<int> getUnreadCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Marcar como lida
  @override
  Future<int> markAsRead(String notificationId) async {
    final db = await database;
    return await db.update(
      tableName,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  // Marcar todas como lidas
  @override
  Future<int> markAllAsRead(String userId) async {
    final db = await database;
    return await db.update(
      tableName,
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Notificações por tipo
  @override
  Future<List<NotificationModel>> getByType(String userId, String type) async {
    return await getWhere('user_id = ? AND type = ?', [userId, type]);
  }

  // Deletar notificações antigas (+ de 30 dias)
  @override
  Future<int> deleteOldNotifications(String userId) async {
    final db = await database;
    final thirtyDaysAgo = DateTime.now()
        .subtract(Duration(days: 30))
        .toIso8601String();
    return await db.delete(
      tableName,
      where: 'user_id = ? AND created_at < ?',
      whereArgs: [userId, thirtyDaysAgo],
    );
  }
}
