// domain/usecases/loyalty/get_loyalty_card_usecase.dart

import '../../entities/loyalty_card_entity.dart';
import '../../repositories/loyalty_repository_protocol.dart';

class GetLoyaltyCardUseCase {
  final LoyaltyRepositoryProtocol _repository;

  GetLoyaltyCardUseCase(this._repository);

  Future<LoyaltyCardEntity?> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.getLoyaltyCard(userId);
    } catch (e) {
      print('❌ Erro ao buscar cartão fidelidade: $e');
      rethrow;
    }
  }
}
