// models/challenge_model.dart
class ChallengeModel {
  final String id;
  final String? userId;
  final String title;
  final String description;
  final String challengeType;
  final int targetCount;
  final int currentCount;
  final int rewardPoints;
  final String? rewardBadge;
  final String? rewardDiscount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  ChallengeModel({
    required this.id,
    this.userId,
    required this.title,
    required this.description,
    required this.challengeType,
    required this.targetCount,
    this.currentCount = 0,
    this.rewardPoints = 0,
    this.rewardBadge,
    this.rewardDiscount,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      challengeType: map['challenge_type'],
      targetCount: map['target_count'],
      currentCount: map['current_count'] ?? 0,
      rewardPoints: map['reward_points'] ?? 0,
      rewardBadge: map['reward_badge'],
      rewardDiscount: map['reward_discount'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      isActive: map['is_active'] == 1,
      isCompleted: map['is_completed'] == 1,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'challenge_type': challengeType,
      'target_count': targetCount,
      'current_count': currentCount,
      'reward_points': rewardPoints,
      'reward_badge': rewardBadge,
      'reward_discount': rewardDiscount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive ? 1 : 0,
      'is_completed': isCompleted ? 1 : 0,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }
}
