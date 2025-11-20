// data/repositories/loyalty_repository_impl.dart

import 'package:vivar/domain/entity/acitivty/activity_entity.dart';
import 'package:vivar/domain/entity/benefit/benefit_entity.dart';
import 'package:vivar/domain/entity/loyalt/loyalty_card_entity.dart';
import 'package:vivar/domain/interface/loyalty/loyalty_repository_protocol.dart';
import 'package:vivar/screens/loyalty_card/data/datasource/loyalty_datasource.dart';

/// Implementação do repositório de fidelidade
/// Delega operações de dados para o datasource
class LoyaltyRepositoryImpl implements LoyaltyRepositoryProtocol {
  final LoyaltyDatasourceProtocol _datasource;

  LoyaltyRepositoryImpl({required LoyaltyDatasourceProtocol datasource})
    : _datasource = datasource;

  @override
  Future<LoyaltyCardEntity?> getLoyaltyCard(String userId) {
    return _datasource.getLoyaltyCard(userId);
  }

  @override
  Future<List<BenefitEntity>> getActiveBenefits(String userId) {
    return _datasource.getActiveBenefits(userId);
  }

  @override
  Future<List<ActivityEntity>> getRecentActivities(
    String userId, {
    int limit = 10,
  }) {
    return _datasource.getRecentActivities(userId, limit: limit);
  }

  @override
  Future<void> redeemBenefit(String userId, String benefitId) {
    return _datasource.redeemBenefit(userId, benefitId);
  }

  @override
  Future<String> generateQRCode(String userId) async {
    return _datasource.generateQRCode(userId);
  }
}
