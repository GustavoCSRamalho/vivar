// presentation/providers/subscription_provider_factory.dart

import '../data/datasource/subscription_local_datasource.dart';
import '../data/repositories/subscription_repository_impl.dart';
import '../domain/usecase/cancel_subscription_usecase.dart';
import '../domain/usecase/get_available_plans_usecase.dart';
import '../domain/usecase/get_user_subscription_usecase.dart';
import '../domain/usecase/subscribe_to_plan_usecase.dart';
import '../presentation/providers/subscription_provider.dart';

class SubscriptionProviderFactory {
  static SubscriptionProvider create() {
    final datasource = SubscriptionLocalDataSource();
    final repository = SubscriptionRepositoryImpl(datasource: datasource);

    final getAvailablePlansUseCase = GetAvailablePlansUseCase(repository);
    final getUserSubscriptionUseCase = GetUserSubscriptionUseCase(repository);
    final subscribeToPlanUseCase = SubscribeToPlanUseCase(repository);
    final cancelSubscriptionUseCase = CancelSubscriptionUseCase(repository);

    return SubscriptionProvider(
      getAvailablePlansUseCase: getAvailablePlansUseCase,
      getUserSubscriptionUseCase: getUserSubscriptionUseCase,
      subscribeToPlanUseCase: subscribeToPlanUseCase,
      cancelSubscriptionUseCase: cancelSubscriptionUseCase,
    );
  }
}
