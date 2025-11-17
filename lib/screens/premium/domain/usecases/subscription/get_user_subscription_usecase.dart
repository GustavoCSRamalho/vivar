// domain/usecases/subscription/get_user_subscription_usecase.dart

import '../../entities/user_subscription_entity.dart';
import '../../repositories/subscription_repository_protocol.dart';

class GetUserSubscriptionUseCase {
  final SubscriptionRepositoryProtocol _repository;

  GetUserSubscriptionUseCase(this._repository);

  Future<UserSubscriptionEntity?> execute(String userId) async {
    try {
      return await _repository.getUserSubscription(userId);
    } catch (e) {
      print('❌ Erro ao buscar assinatura: $e');
      return null;
    }
  }
}
