// domain/entities/challenge_entity.dart

class ChallengeEntity {
  final String id;
  final String title;
  final String description;
  final String challengeType; // 'checkin', 'explore', 'social', 'points'
  final int targetCount;
  final int currentCount;
  final int rewardPoints;
  final String? rewardBadge;
  final String? rewardDiscount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final DateTime? completedAt;

  ChallengeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.challengeType,
    required this.targetCount,
    required this.currentCount,
    required this.rewardPoints,
    this.rewardBadge,
    this.rewardDiscount,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
    this.completedAt,
  });

  double get progress => currentCount / targetCount;
  bool get isActive => !isCompleted && DateTime.now().isBefore(endDate);
  int get daysLeft => endDate.difference(DateTime.now()).inDays;
}
