// domain/usecases/place/filter_businesses_by_category_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_entity.dart';

class FilterPlacesByCategoryUseCase {
  FilterPlacesByCategoryUseCase();

  List<BusinessEntity> execute({
    required List<BusinessEntity> businesses,
    required String category,
  }) {
    try {
      if (category == 'Todos') {
        return businesses;
      }

      return businesses.where((place) => place.category == category).toList();
    } catch (e) {
      print('❌ Erro ao filtrar por categoria: $e');
      return businesses;
    }
  }
}
