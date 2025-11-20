// domain/usecases/subscription/get_available_plans_usecase.dart

import '../../entity/subscription/subscription_plan_entity.dart';
import '../../interface/subscription/subscription_repository_protocol.dart';

class GetAvailablePlansUseCase {
  final SubscriptionRepositoryProtocol _repository;

  GetAvailablePlansUseCase(this._repository);

  Future<List<SubscriptionPlanEntity>> execute() async {
    try {
      return await _repository.getAvailablePlans();
    } catch (e) {
      print('❌ Erro ao buscar planos: $e');
      rethrow;
    }
  }
}
