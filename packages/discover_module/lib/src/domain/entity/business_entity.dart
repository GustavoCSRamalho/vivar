// domain/entities/business_entity.dart

class BusinessEntity {
  final String id;
  final String? userId;

  final String name;
  final String category;
  final String? description;

  final String address;
  final String city;
  final String state;

  final double latitude;
  final double longitude;

  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? website;

  final Map<String, dynamic>? schedule;
  final bool isWhatsapp;

  final double rating;
  final int reviewsCount;

  final String? priceRange;
  final bool isOpen;

  final Map<String, dynamic>? openingHours;

  final List<String> amenities;
  final List<String> images;

  final String? discountText;
  final int discountPercentage;

  final bool isPremiumOnly;

  final double? distance;

  final DateTime createdAt;
  final DateTime updatedAt;

  final bool synced;

  BusinessEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.category,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.whatsapp,
    this.email,
    this.website,
    this.schedule,
    this.isWhatsapp = false,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.priceRange,
    this.isOpen = true,
    this.openingHours,
    this.amenities = const [],
    this.images = const [],
    this.discountText,
    this.discountPercentage = 0,
    this.isPremiumOnly = false,
    this.distance,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  // Getters úteis
  bool get hasDiscount => discountPercentage > 0;

  bool get hasImages => images.isNotEmpty;

  bool get hasAmenities => amenities.isNotEmpty;

  String? get firstImage => hasImages ? images.first : null;

  String get fullAddress => '$address, $city - $state';

  String get formattedDistance {
    if (distance == null) return 'N/A';
    if (distance! < 1000) {
      return '${distance!.toStringAsFixed(0)}m';
    }
    return '${(distance! / 1000).toStringAsFixed(1)}km';
  }

  String get categoryWithPrice {
    if (priceRange != null) {
      return '$category · $priceRange';
    }
    return category;
  }
}
