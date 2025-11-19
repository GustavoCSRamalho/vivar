// domain/entities/benefit_entity.dart

class BenefitEntity {
  final String id;
  final String merchantId;
  final String merchantName;
  final String title;
  final String description;
  final String discountType; // 'percentage', 'fixed', 'freeItem'
  final double discountValue;
  final DateTime validUntil;
  final bool isActive;
  final int pointsCost;

  BenefitEntity({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.validUntil,
    required this.isActive,
    required this.pointsCost,
  });
}
