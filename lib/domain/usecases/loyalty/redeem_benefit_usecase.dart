// domain/usecases/loyalty/redeem_benefit_usecase.dart

import '../../interface/loyalty/loyalty_repository_protocol.dart';

class RedeemBenefitUseCase {
  final LoyaltyRepositoryProtocol _repository;

  RedeemBenefitUseCase(this._repository);

  Future<void> execute(String userId, String benefitId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    if (benefitId.trim().isEmpty) {
      throw Exception('ID do benefício é obrigatório');
    }

    try {
      await _repository.redeemBenefit(userId, benefitId);
    } catch (e) {
      print('❌ Erro ao resgatar benefício: $e');
      rethrow;
    }
  }
}
