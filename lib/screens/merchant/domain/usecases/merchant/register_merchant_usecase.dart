// domain/usecases/merchant/register_merchant_usecase.dart

import '../../entities/merchant_entity.dart';
import '../../repositories/merchant_repository_protocol.dart';

class RegisterMerchantUseCase {
  final MerchantRepositoryProtocol _repository;

  RegisterMerchantUseCase(this._repository);

  Future<void> execute(MerchantEntity merchant) async {
    try {
      await _repository.registerMerchant(merchant);
    } catch (e) {
      print('❌ Erro ao registrar estabelecimento: $e');
      rethrow;
    }
  }
}
