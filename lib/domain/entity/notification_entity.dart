// domain/entities/notification_entity.dart

/// Entidade de domínio para Notification
class NotificationEntity {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  /// Verifica se é uma notificação de oferta
  bool get isOffer => type == 'offer';

  /// Verifica se é uma notificação de check-in
  bool get isCheckin => type == 'checkin';

  /// Verifica se é uma notificação de badge
  bool get isBadge => type == 'badge';

  /// Verifica se é uma notificação do sistema
  bool get isSystem => type == 'system';
}
