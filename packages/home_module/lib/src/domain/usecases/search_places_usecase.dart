// domain/usecases/place/search_businesses_usecase.dart

import '../entity/business_entity.dart';
import '../interfaces/place_repository_protocol.dart';

class SearchBusinessesUseCase {
  final BusinessesRepositoryProtocol _placeRepository;

  SearchBusinessesUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      return await _placeRepository.searchBusinesses(query.trim());
    } catch (e) {
      print('❌ Erro ao buscar lugares: $e');
      rethrow;
    }
  }
}
