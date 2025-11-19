// domain/usecases/place/filter_places_by_category_usecase.dart

import '../../entity/place_entity.dart';

class FilterPlacesByCategoryUseCase {
  FilterPlacesByCategoryUseCase();

  List<PlaceEntity> execute({
    required List<PlaceEntity> places,
    required String category,
  }) {
    try {
      if (category == 'Todos') {
        return places;
      }

      return places.where((place) => place.category == category).toList();
    } catch (e) {
      print('❌ Erro ao filtrar por categoria: $e');
      return places;
    }
  }
}
