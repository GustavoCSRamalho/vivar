// core/repositories/notification_repository.dart
import '../database/database_helper.dart';
import '../../models/notification_model.dart';
import 'base_repository.dart';
import 'package:sqflite/sqflite.dart';

class NotificationRepository extends BaseRepository<NotificationModel> {
  @override
  String get tableName => 'notifications';

  @override
  NotificationModel fromMap(Map<String, dynamic> map) =>
      NotificationModel.fromMap(map);

  @override
  Map<String, dynamic> toMap(NotificationModel model) => model.toMap();

  // Notificações do usuário
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
  Future<List<NotificationModel>> getUnreadNotifications(String userId) async {
    return await getWhere('user_id = ? AND is_read = 0', [userId]);
  }

  // Contagem de não lidas
  Future<int> getUnreadCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Marcar como lida
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
  Future<List<NotificationModel>> getByType(String userId, String type) async {
    return await getWhere('user_id = ? AND type = ?', [userId, type]);
  }

  // Deletar notificações antigas (+ de 30 dias)
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
