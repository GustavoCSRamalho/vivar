// domain/repositories/subscription_repository_protocol.dart

import '../entities/subscription_plan_entity.dart';
import '../entities/user_subscription_entity.dart';

abstract class SubscriptionRepositoryProtocol {
  Future<List<SubscriptionPlanEntity>> getAvailablePlans();
  Future<UserSubscriptionEntity?> getUserSubscription(String userId);
  Future<void> subscribeToPlan(String userId, String planId, bool isYearly);
  Future<void> cancelSubscription(String userId);
}
