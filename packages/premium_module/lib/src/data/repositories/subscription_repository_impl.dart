import 'package:premium_module/src/domain/entity/subscription_plan_entity.dart';
import 'package:premium_module/src/domain/entity/user_subscription_entity.dart';
import 'package:premium_module/src/domain/interfaces/subscription_repository_protocol.dart';
import '../datasource/subscription_local_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepositoryProtocol {
  final SubscriptionLocalDataSourceProtocol datasource;

  SubscriptionRepositoryImpl({required this.datasource});

  @override
  Future<List<SubscriptionPlanEntity>> getAvailablePlans() {
    return datasource.getAvailablePlans();
  }

  @override
  Future<UserSubscriptionEntity?> getUserSubscription(String userId) {
    return datasource.getUserSubscription(userId);
  }

  @override
  Future<void> subscribeToPlan(String userId, String planId, bool isYearly) {
    return datasource.subscribeToPlan(userId, planId, isYearly);
  }

  @override
  Future<void> cancelSubscription(String userId) {
    return datasource.cancelSubscription(userId);
  }
}
