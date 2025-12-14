// domain/usecases/subscription/get_user_subscription_usecase.dart

import 'package:premium_module/src/domain/entity/user_subscription_entity.dart';
import 'package:premium_module/src/domain/interfaces/subscription_repository_protocol.dart';

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
