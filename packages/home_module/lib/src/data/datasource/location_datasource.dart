// data/datasources/location/location_datasource_impl.dart

import 'package:geolocator/geolocator.dart' as geo;

// data/datasources/location/location_datasource_protocol.dart

/// Contrato abstrato para datasource de localização
/// Define os métodos que devem ser implementados para converter dados de localização
abstract class LocationDatasourceProtocol {
  /// Converte a posição do Geolocator para o formato interno
  ///
  /// [geoPosition] - Posição retornada pelo pacote Geolocator
  /// Retorna objeto [geo.Position] processado
  geo.Position convertGeolocatorPosition(geo.Position geoPosition);
}

/// Implementação do datasource de localização
/// Contém a lógica de conversão e adaptação de dados do Geolocator
/// Serve como ponte entre o pacote externo e a aplicação
class LocationDatasourceImpl implements LocationDatasourceProtocol {
  @override
  geo.Position convertGeolocatorPosition(geo.Position geoPosition) {
    try {
      // Retorna a posição do Geolocator diretamente
      // Aqui poderia haver validações ou transformações se necessário
      return geoPosition;
    } catch (e) {
      print('❌ Erro ao converter posição do Geolocator: $e');
      rethrow;
    }
  }
}
