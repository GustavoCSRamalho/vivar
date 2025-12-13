// data/usecases/location/request_location_permission_usecase_impl.dart

import 'package:location_module/src/domain/interfaces/location_permission_repository_protocol.dart';
import 'package:location_module/src/domain/interfaces/request_location_permission_protocol.dart';

class RequestLocationPermissionUseCase
    implements RequestLocationPermissionProtocol {
  final LocationPermissionRepositoryProtocol _repository;

  RequestLocationPermissionUseCase(this._repository);

  @override
  Future<LocationPermissionResult> execute() async {
    try {
      return await _repository.requestPermission();
    } catch (e) {
      print('❌ Erro ao solicitar permissão: $e');
      return LocationPermissionResult.denied;
    }
  }
}
