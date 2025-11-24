// domain/usecases/place/apply_advanced_filters_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_entity.dart';
import '../../interface/place/place_repository_protocol.dart';

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
