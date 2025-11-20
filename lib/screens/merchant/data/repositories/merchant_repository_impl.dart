// data/repositories/merchant_repository_impl.dart

import 'package:vivar/domain/entity/merchant/merchant_entity.dart';
import 'package:vivar/domain/interface/merchant/merchant_repository_protocol.dart';
import 'package:vivar/screens/merchant/data/datasource/merchant_datasource.dart';

/// Implementação do repositório de comerciantes
/// Delega operações de dados para o datasource
class MerchantRepositoryImpl implements MerchantRepositoryProtocol {
  final MerchantDatasourceProtocol _datasource;

  MerchantRepositoryImpl({required MerchantDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<void> registerMerchant(MerchantEntity merchant) {
    return _datasource.registerMerchant(merchant);
  }

  @override
  Future<MerchantEntity?> getMerchantById(String merchantId) {
    return _datasource.getMerchantById(merchantId);
  }

  @override
  Future<List<MerchantEntity>> getUserMerchants(String userId) {
    return _datasource.getUserMerchants(userId);
  }
}
