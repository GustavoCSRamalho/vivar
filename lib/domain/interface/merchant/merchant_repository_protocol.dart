// domain/repositories/merchant_repository_protocol.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/merchant/merchant_entity.dart';

abstract class MerchantRepositoryProtocol {
  Future<void> registerMerchant(BusinessEntity merchant);
  Future<BusinessEntity?> getMerchantById(String merchantId);
  Future<List<BusinessEntity>> getUserMerchants(String userId);
}
