// domain/repositories/loyalty_repository_protocol.dart

import '../entities/loyalty_card_entity.dart';
import '../entities/benefit_entity.dart';
import '../entities/activity_entity.dart';

abstract class LoyaltyRepositoryProtocol {
  Future<LoyaltyCardEntity?> getLoyaltyCard(String userId);
  Future<List<BenefitEntity>> getActiveBenefits(String userId);
  Future<List<ActivityEntity>> getRecentActivities(
    String userId, {
    int limit = 10,
  });
  Future<void> redeemBenefit(String userId, String benefitId);
  Future<String> generateQRCode(String userId);
}
