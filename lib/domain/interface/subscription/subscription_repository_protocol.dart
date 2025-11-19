// domain/repositories/subscription_repository_protocol.dart

import '../../entity/subscription_plan_entity.dart';
import '../../entity/user_subscription_entity.dart';

abstract class SubscriptionRepositoryProtocol {
  Future<List<SubscriptionPlanEntity>> getAvailablePlans();
  Future<UserSubscriptionEntity?> getUserSubscription(String userId);
  Future<void> subscribeToPlan(String userId, String planId, bool isYearly);
  Future<void> cancelSubscription(String userId);
}
