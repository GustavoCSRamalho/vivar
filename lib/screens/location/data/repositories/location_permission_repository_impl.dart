// data/repositories/location_permission_repository_impl.dart

import 'package:vivar/domain/interface/location/location_permission_repository_protocol.dart';
import 'package:vivar/domain/interface/location/request_location_permission_protocol.dart';
import 'package:vivar/screens/location/data/datasource/location_permission_datasource.dart';

/// Implementação do repositório de permissões de localização
/// Delega todas as operações para o datasource
/// Responsável apenas por orquestrar a comunicação entre domain e data layers
class LocationPermissionRepositoryImpl
    implements LocationPermissionRepositoryProtocol {
  final LocationPermissionDatasourceProtocol _datasource;

  LocationPermissionRepositoryImpl({
    required LocationPermissionDatasourceProtocol datasource,
  }) : _datasource = datasource;

  @override
  Future<LocationPermissionResult> requestPermission() {
    return _datasource.requestPermission();
  }

  @override
  Future<bool> hasPermission() {
    return _datasource.checkPermissionStatus();
  }

  @override
  Future<void> openSettings() {
    return _datasource.openAppSettings();
  }
}
