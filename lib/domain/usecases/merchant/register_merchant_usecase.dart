// domain/usecases/merchant/register_merchant_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/merchant/merchant_entity.dart';
import '../../interface/merchant/merchant_repository_protocol.dart';

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
