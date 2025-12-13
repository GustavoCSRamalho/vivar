// domain/usecases/merchant/register_merchant_usecase.dart

import 'package:merchant_module/src/domain/entity/business_entity.dart';
import 'package:merchant_module/src/domain/interfaces/merchant_repository_protocol.dart';

class RegisterMerchantUseCase {
  final MerchantRepositoryProtocol _repository;

  RegisterMerchantUseCase(this._repository);

  Future<void> execute(BusinessEntity merchant) async {
    try {
      await _repository.registerMerchant(merchant);
    } catch (e) {
      print('❌ Erro ao registrar estabelecimento: $e');
      rethrow;
    }
  }
}
