// domain/entities/map_place_entity.dart

class MapPlaceEntity {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final double rating;
  final String? distance;
  final String? discount;
  final bool isOpen;
  final String? imageUrl;

  MapPlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.distance,
    this.discount,
    required this.isOpen,
    this.imageUrl,
  });

  bool get hasDiscount => discount != null && discount!.isNotEmpty;
}
