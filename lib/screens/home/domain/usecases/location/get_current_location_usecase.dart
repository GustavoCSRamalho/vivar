import 'package:vivar/core/services/location_service.dart';
import '../../entities/position_entity.dart';
import '../../repositories/location_repository_protocol.dart';

class GetCurrentLocationUseCase {
  final LocationService _locationService;
  final LocationRepositoryProtocol _locationRepository;

  GetCurrentLocationUseCase(this._locationService, this._locationRepository);

  Future<Position?> execute() async {
    try {
      // 1. service ligado?
      final isEnabled = await _locationService.isLocationServiceEnabled();
      if (!isEnabled) return null;

      // 2. permissao
      final hasPermission = await _locationService.hasPermission();
      if (!hasPermission) {
        final granted = await _locationService.requestPermission();
        if (!granted) return null;
      }

      // 3. pegar geoPosition bruto
      final geoPosition = await _locationService.getCurrentLocation();
      if (geoPosition == null) return null;

      // 4. converter para domínio
      return _locationRepository.toDomainPosition(geoPosition);
    } catch (e) {
      print('❌ Erro ao obter localização: $e');
      return null;
    }
  }
}
