// data/repositories/notification_repository_impl.dart

import 'package:sqflite/sqflite.dart';
import 'package:vivar/core/database/database_helper.dart';
import 'package:vivar/models/notification_model.dart';
import 'package:vivar/domain/entity/notification_entity.dart';
import 'package:vivar/domain/interface/notification/notification_repository_protocol.dart';

class NotificationRepositoryImpl implements NotificationRepositoryProtocol {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final String tableName = 'notifications';

  Future<Database> get _database async => await _dbHelper.database;

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return maps
        .map((map) => _modelToEntity(NotificationModel.fromMap(map)))
        .toList();
  }

  @override
  Future<List<NotificationEntity>> getUnreadNotifications(String userId) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ? AND is_read = 0',
      whereArgs: [userId],
    );
    return maps
        .map((map) => _modelToEntity(NotificationModel.fromMap(map)))
        .toList();
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final db = await _database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ? AND is_read = 0',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final db = await _database;
    await db.update(
      tableName,
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [notificationId],
    );
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final db = await _database;
    await db.update(
      tableName,
      {'is_read': 1},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> addNotification(NotificationEntity notification) async {
    final db = await _database;
    final model = _entityToModel(notification);
    await db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteOldNotifications(String userId) async {
    final db = await _database;
    final thirtyDaysAgo = DateTime.now()
        .subtract(Duration(days: 30))
        .toIso8601String();
    await db.delete(
      tableName,
      where: 'user_id = ? AND created_at < ?',
      whereArgs: [userId, thirtyDaysAgo],
    );
  }

  NotificationEntity _modelToEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      userId: model.userId,
      type: model.type,
      title: model.title,
      message: model.message,
      data: model.data,
      isRead: model.isRead,
      createdAt: model.createdAt,
    );
  }

  NotificationModel _entityToModel(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      message: entity.message,
      data: entity.data,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }
}
