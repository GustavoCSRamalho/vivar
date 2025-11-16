// domain/entities/discover_collection_entity.dart

class DiscoverCollectionEntity {
  final String id;
  final String title;
  final String category;
  final String description;
  final String? imageUrl;
  final int placesCount;
  final List<String>? placeIds;

  DiscoverCollectionEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    this.imageUrl,
    required this.placesCount,
    this.placeIds,
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}
