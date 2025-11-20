import 'package:vivar/screens/premium/data/datasource/subscription_local_datasource.dart';

import '../../../../domain/interface/subscription/subscription_repository_protocol.dart';
import '../../../../domain/entity/subscription/subscription_plan_entity.dart';
import '../../../../domain/entity/user/user_subscription_entity.dart';

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
