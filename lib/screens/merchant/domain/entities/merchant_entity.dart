// domain/entities/merchant_entity.dart

class MerchantEntity {
  final String id;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String email;
  final String description;
  final List<String> images;
  final Map<String, String> schedule;
  final List<String> amenities;
  final bool isWhatsapp;
  final String status;
  final DateTime createdAt;

  MerchantEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.email,
    required this.description,
    required this.images,
    required this.schedule,
    required this.amenities,
    required this.isWhatsapp,
    this.status = 'pending',
    required this.createdAt,
  });
}
