// data/repositories/notification_repository_impl.dart

import 'package:vivar/models/notification_model.dart';
import 'package:vivar/domain/entity/notification/notification_entity.dart';
import 'package:vivar/domain/interface/notification/notification_repository_protocol.dart';
import 'package:vivar/screens/home/data/datasource/notification_datasource.dart';

/// Implementação do repositório de notificações
/// Delega operações de dados para o datasource
/// Responsável por converter entre Model (data layer) e Entity (domain layer)
class NotificationRepositoryImpl implements NotificationRepositoryProtocol {
  final NotificationDatasourceProtocol _datasource;

  NotificationRepositoryImpl({
    required NotificationDatasourceProtocol datasource,
  }) : _datasource = datasource;

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) async {
    final models = await _datasource.getUserNotifications(userId);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<List<NotificationEntity>> getUnreadNotifications(String userId) async {
    final models = await _datasource.getUnreadNotifications(userId);
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<int> getUnreadCount(String userId) {
    return _datasource.getUnreadCount(userId);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _datasource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _datasource.markAllAsRead(userId);
  }

  @override
  Future<void> addNotification(NotificationEntity notification) async {
    final model = _entityToModel(notification);
    await _datasource.addNotification(model);
  }

  @override
  Future<void> deleteOldNotifications(String userId) {
    return _datasource.deleteOldNotifications(userId);
  }

  /// Converte NotificationModel (data layer) para NotificationEntity (domain layer)
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

  /// Converte NotificationEntity (domain layer) para NotificationModel (data layer)
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
