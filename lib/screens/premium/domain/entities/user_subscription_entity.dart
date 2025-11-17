// domain/entities/user_subscription_entity.dart

class UserSubscriptionEntity {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  UserSubscriptionEntity({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });
}
