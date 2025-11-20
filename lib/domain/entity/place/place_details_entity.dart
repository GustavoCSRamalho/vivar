// domain/entities/place_details_entity.dart

class PlaceDetailsEntity {
  final String id;
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
  final double rating;
  final int reviewsCount;
  final String? priceRange;
  final bool isOpen;
  final String? openingHours;
  final List<String>? amenities;
  final List<String>? images;
  final String? discountText;
  final int? discountPercentage;
  final bool isPremiumOnly;
  final double? distance;

  PlaceDetailsEntity({
    required this.id,
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
    required this.rating,
    required this.reviewsCount,
    this.priceRange,
    required this.isOpen,
    this.openingHours,
    this.amenities,
    this.images,
    this.discountText,
    this.discountPercentage,
    required this.isPremiumOnly,
    this.distance,
  });

  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;
  bool get hasImages => images != null && images!.isNotEmpty;
  bool get hasAmenities => amenities != null && amenities!.isNotEmpty;
  String get fullAddress => '$address, $city - $state';
}
