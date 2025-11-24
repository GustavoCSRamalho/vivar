// domain/usecases/place/search_businesses_usecase.dart

import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_entity.dart';
import '../../interface/place/place_repository_protocol.dart';

class SearchPlacesUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  SearchPlacesUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      return await _placeRepository.searchPlaces(query.trim());
    } catch (e) {
      print('❌ Erro ao buscar lugares: $e');
      rethrow;
    }
  }
}
