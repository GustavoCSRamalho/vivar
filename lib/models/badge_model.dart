// models/badge_model.dart
class BadgeModel {
  final String id;
  final String userId;
  final String badgeType;
  final String name;
  final String description;
  final String icon;
  final DateTime earnedAt;
  final bool synced;

  BadgeModel({
    required this.id,
    required this.userId,
    required this.badgeType,
    required this.name,
    required this.description,
    required this.icon,
    required this.earnedAt,
    this.synced = false,
  });

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      id: map['id'],
      userId: map['user_id'],
      badgeType: map['badge_type'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      earnedAt: DateTime.parse(map['earned_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'badge_type': badgeType,
      'name': name,
      'description': description,
      'icon': icon,
      'earned_at': earnedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }
}
