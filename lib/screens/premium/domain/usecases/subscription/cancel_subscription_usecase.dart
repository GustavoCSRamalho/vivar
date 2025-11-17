// domain/usecases/subscription/cancel_subscription_usecase.dart

import '../../repositories/subscription_repository_protocol.dart';

class CancelSubscriptionUseCase {
  final SubscriptionRepositoryProtocol _repository;

  CancelSubscriptionUseCase(this._repository);

  Future<void> execute(String userId) async {
    try {
      await _repository.cancelSubscription(userId);
    } catch (e) {
      print('❌ Erro ao cancelar assinatura: $e');
      rethrow;
    }
  }
}
