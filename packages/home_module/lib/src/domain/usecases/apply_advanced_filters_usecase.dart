// domain/usecases/place/apply_advanced_filters_usecase.dart

import '../entity/business_entity.dart';
import '../interfaces/place_repository_protocol.dart';

class ApplyAdvancedFiltersUseCase {
  final BusinessesRepositoryProtocol _placeRepository;

  ApplyAdvancedFiltersUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute({
    List<String>? categories,
    String? priceRange,
    double? minRating,
    List<String>? amenities,
    bool? openNow,
  }) async {
    try {
      return await _placeRepository.getFilteredBusinesses(
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
