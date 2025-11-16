// domain/usecases/place/apply_advanced_filters_usecase.dart

import '../../entities/place_entity.dart';
import '../../repositories/place_repository_protocol.dart';

class ApplyAdvancedFiltersUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  ApplyAdvancedFiltersUseCase(this._placeRepository);

  Future<List<PlaceEntity>> execute({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    try {
      return await _placeRepository.getFilteredPlaces(
        categories: categories,
        priceRange: priceRange,
        minRating: minRating,
        amenities: amenities,
        openNow: openNow,
      );
    } catch (e) {
      print('❌ Erro ao aplicar filtros: $e');
      rethrow;
    }
  }
}
