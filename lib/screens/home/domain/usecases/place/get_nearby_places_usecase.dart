// domain/usecases/place/get_nearby_places_usecase.dart

import 'package:vivar/core/services/location_service.dart';

import '../../entities/place_entity.dart';
import '../../repositories/place_repository_protocol.dart';

class GetNearbyPlacesUseCase {
  final PlaceRepositoryProtocol _placeRepository;
  final LocationService _locationService;

  GetNearbyPlacesUseCase(this._placeRepository, this._locationService);

  Future<List<PlaceEntity>> execute({
    required double userLatitude,
    required double userLongitude,
    double radiusKm = 5.0,
  }) async {
    try {
      final places = await _placeRepository.getNearbyPlaces(
        latitude: userLatitude,
        longitude: userLongitude,
        radiusKm: radiusKm,
      );

      final placesWithDistance = places.map((place) {
        final distance = _locationService.getDistanceBetween(
          userLatitude,
          userLongitude,
          place.latitude,
          place.longitude,
        );

        return PlaceEntity(
          id: place.id,
          name: place.name,
          category: place.category,
          description: place.description,
          address: place.address,
          city: place.city,
          state: place.state,
          latitude: place.latitude,
          longitude: place.longitude,
          phone: place.phone,
          whatsapp: place.whatsapp,
          email: place.email,
          website: place.website,
          rating: place.rating,
          reviewsCount: place.reviewsCount,
          priceRange: place.priceRange,
          isOpen: place.isOpen,
          openingHours: place.openingHours,
          amenities: place.amenities,
          images: place.images,
          discountText: place.discountText,
          discountPercentage: place.discountPercentage,
          isPremiumOnly: place.isPremiumOnly,
          distance: distance,
          createdAt: place.createdAt,
          updatedAt: place.updatedAt,
        );
      }).toList();

      placesWithDistance.sort((a, b) {
        if (a.distance == null && b.distance == null) return 0;
        if (a.distance == null) return 1;
        if (b.distance == null) return -1;
        return a.distance!.compareTo(b.distance!);
      });

      return placesWithDistance;
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos: $e');
      rethrow;
    }
  }
}
