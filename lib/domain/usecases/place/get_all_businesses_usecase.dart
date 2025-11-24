// domain/usecases/place/get_all_businesses_usecase.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/business/business_entity.dart';

import '../../entity/place/place_entity.dart';
import '../../interface/place/place_repository_protocol.dart';

class GetAllBusinessesUseCase {
  final PlaceRepositoryProtocol _placeRepository;

  GetAllBusinessesUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute() async {
    try {
      debugPrint('🌍 Carregando todos os lugares do repositorio...');
      return await _placeRepository.getAllPlaces();
    } catch (e) {
      print('❌ Erro ao buscar todos os lugares: $e');
      rethrow;
    }
  }
}
