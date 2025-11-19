// domain/entities/swipe_place_entity.dart

class SwipePlaceEntity {
  final String id;
  final String name;
  final String category;
  final String description;
  final double rating;
  final String priceRange;
  final double distance;
  final List<String> tags;
  final List<String>? images;
  final String? discount;
  final bool isOpen;

  SwipePlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.priceRange,
    required this.distance,
    required this.tags,
    this.images,
    this.discount,
    required this.isOpen,
  });

  bool get hasDiscount => discount != null && discount!.isNotEmpty;
  bool get hasImages => images != null && images!.isNotEmpty;
  String? get firstImage => hasImages ? images!.first : null;
}
