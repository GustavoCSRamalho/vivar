// presentation/providers/subscription_provider_factory.dart

import 'package:vivar/screens/premium/data/repositories/subscription_repository_impl.dart';
import 'package:vivar/screens/premium/domain/usecases/subscription/cancel_subscription_usecase.dart';
import 'package:vivar/screens/premium/domain/usecases/subscription/get_available_plans_usecase.dart';
import 'package:vivar/screens/premium/domain/usecases/subscription/get_user_subscription_usecase.dart';
import 'package:vivar/screens/premium/domain/usecases/subscription/subscribe_to_plan_usecase.dart';
import 'package:vivar/screens/premium/presentation/providers/subscription_provider.dart';

class SubscriptionProviderFactory {
  static SubscriptionProvider create() {
    final repository = SubscriptionRepositoryImpl();

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
