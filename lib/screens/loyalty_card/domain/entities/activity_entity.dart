// domain/entities/activity_entity.dart

class ActivityEntity {
  final String id;
  final String userId;
  final String type; // 'checkin', 'coupon', 'badge', 'points'
  final String title;
  final String subtitle;
  final int pointsChange;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ActivityEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.pointsChange,
    required this.timestamp,
    this.metadata,
  });
}
