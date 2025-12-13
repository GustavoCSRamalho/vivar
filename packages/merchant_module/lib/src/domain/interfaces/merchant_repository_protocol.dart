// domain/repositories/merchant_repository_protocol.dart

import 'package:merchant_module/src/domain/entity/business_entity.dart';

abstract class MerchantRepositoryProtocol {
  Future<void> registerMerchant(BusinessEntity merchant);
  Future<BusinessEntity?> getMerchantById(String merchantId);
  Future<List<BusinessEntity>> getUserMerchants(String userId);
}
