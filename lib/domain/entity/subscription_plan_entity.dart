// domain/entities/subscription_plan_entity.dart

class SubscriptionPlanEntity {
  final String id;
  final String name;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isPopular;
  final String badge;

  SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.isPopular = false,
    this.badge = '',
  });

  double get monthlySavings => (monthlyPrice * 12) - yearlyPrice;
  int get savingsPercentage =>
      ((monthlySavings / (monthlyPrice * 12)) * 100).round();
}
