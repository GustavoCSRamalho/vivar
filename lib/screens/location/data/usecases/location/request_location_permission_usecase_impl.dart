// data/usecases/location/request_location_permission_usecase_impl.dart

import 'package:vivar/screens/location/domain/repositories/location_permission_repository_protocol.dart';
import 'package:vivar/screens/location/domain/usecases/location/request_location_permission_usecase.dart';

class RequestLocationPermissionUseCaseImpl
    implements RequestLocationPermissionUseCase {
  final LocationPermissionRepositoryProtocol _repository;

  RequestLocationPermissionUseCaseImpl(this._repository);

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
