// // domain/entities/place_entity.dart

// class PlaceEntity {
//   final String id;
//   final String name;
//   final String category;
//   final String? description;
//   final String address;
//   final String city;
//   final String state;
//   final double latitude;
//   final double longitude;
//   final String? phone;
//   final String? whatsapp;
//   final String? email;
//   final String? website;
//   final double rating;
//   final int reviewsCount;
//   final String? priceRange;
//   final bool isOpen;
//   final String? openingHours;
//   final List<String>? amenities;
//   final List<String>? images;
//   final String? discountText;
//   final int? discountPercentage;
//   final bool isPremiumOnly;
//   final double? distance;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   PlaceEntity({
//     required this.id,
//     required this.name,
//     required this.category,
//     this.description,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.latitude,
//     required this.longitude,
//     this.phone,
//     this.whatsapp,
//     this.email,
//     this.website,
//     this.rating = 0.0,
//     this.reviewsCount = 0,
//     this.priceRange,
//     this.isOpen = true,
//     this.openingHours,
//     this.amenities,
//     this.images,
//     this.discountText,
//     this.discountPercentage,
//     this.isPremiumOnly = false,
//     this.distance,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   String get formattedDistance {
//     if (distance == null) return 'N/A';
//     if (distance! < 1000) {
//       return '${distance!.toStringAsFixed(0)}m';
//     }
//     return '${(distance! / 1000).toStringAsFixed(1)}km';
//   }

//   bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

//   bool get hasImages => images != null && images!.isNotEmpty;

//   String? get firstImage => hasImages ? images!.first : null;

//   String get categoryWithPrice {
//     if (priceRange != null) {
//       return '$category · $priceRange';
//     }
//     return category;
//   }
// }
