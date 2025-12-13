// domain/usecases/place/get_all_businesses_usecase.dart

import 'package:flutter/foundation.dart';
import '../entity/business_entity.dart';

import '../interfaces/place_repository_protocol.dart';

class GetAllBusinessesUseCase {
  final BusinessesRepositoryProtocol _placeRepository;

  GetAllBusinessesUseCase(this._placeRepository);

  Future<List<BusinessEntity>> execute() async {
    try {
      debugPrint('🌍 Carregando todos os lugares do repositorio...');
      return await _placeRepository.getAllBusinesses();
    } catch (e) {
      print('❌ Erro ao buscar todos os lugares: $e');
      rethrow;
    }
  }
}
