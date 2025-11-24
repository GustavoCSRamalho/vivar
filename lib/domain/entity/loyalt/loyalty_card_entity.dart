// domain/entities/loyalty_card_entity.dart

class LoyaltyCardEntity {
  final String userId;
  final String userName;
  final String userEmail;
  final String cardNumber;
  final String planType;
  final int points;
  final int businessesVisited;
  final int activeCoupons;
  final int badgesCount;
  final int streakDays;
  final DateTime memberSince;

  LoyaltyCardEntity({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.cardNumber,
    required this.planType,
    required this.points,
    required this.businessesVisited,
    required this.activeCoupons,
    required this.badgesCount,
    required this.streakDays,
    required this.memberSince,
  });
}
