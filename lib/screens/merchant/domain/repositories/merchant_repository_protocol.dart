// domain/repositories/merchant_repository_protocol.dart

import '../entities/merchant_entity.dart';

abstract class MerchantRepositoryProtocol {
  Future<void> registerMerchant(MerchantEntity merchant);
  Future<MerchantEntity?> getMerchantById(String merchantId);
  Future<List<MerchantEntity>> getUserMerchants(String userId);
}
