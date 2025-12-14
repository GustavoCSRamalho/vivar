// domain/usecases/subscription/subscribe_to_plan_usecase.dart

import 'package:premium_module/src/domain/interfaces/subscription_repository_protocol.dart';

class SubscribeToPlanUseCase {
  final SubscriptionRepositoryProtocol _repository;

  SubscribeToPlanUseCase(this._repository);

  Future<void> execute(String userId, String planId, bool isYearly) async {
    try {
      await _repository.subscribeToPlan(userId, planId, isYearly);
    } catch (e) {
      print('❌ Erro ao assinar plano: $e');
      rethrow;
    }
  }
}
