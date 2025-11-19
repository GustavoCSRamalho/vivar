// presentation/providers/location_permission_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/interface/location/location_permission_repository_protocol.dart';
import 'package:vivar/domain/interface/check/check_location_permission_usecase.dart';
import 'package:vivar/domain/interface/location/request_location_permission_protocol.dart';
import 'package:vivar/screens/location/data/usecases/location/request_location_permission_usecase_impl.dart';

class LocationPermissionProvider with ChangeNotifier {
  final RequestLocationPermissionUseCase _requestLocationPermissionUseCase;
  final CheckLocationPermissionUseCase _checkLocationPermissionUseCase;
  final LocationPermissionRepositoryProtocol _repository;

  LocationPermissionProvider({
    required RequestLocationPermissionUseCase requestLocationPermissionUseCase,
    required CheckLocationPermissionUseCase checkLocationPermissionUseCase,
    required LocationPermissionRepositoryProtocol repository,
  }) : _requestLocationPermissionUseCase = requestLocationPermissionUseCase,
       _checkLocationPermissionUseCase = checkLocationPermissionUseCase,
       _repository = repository;

  bool _isLoading = false;
  bool _hasPermission = false;
  LocationPermissionResult? _lastResult;

  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  LocationPermissionResult? get lastResult => _lastResult;

  Future<void> checkPermission() async {
    _setLoading(true);

    try {
      _hasPermission = await _checkLocationPermissionUseCase.execute();
      debugPrint('✅ Permissão de localização: $_hasPermission');
    } catch (e) {
      debugPrint('❌ Erro ao verificar permissão: $e');
      _hasPermission = false;
    } finally {
      _setLoading(false);
    }
  }

  Future<LocationPermissionResult> requestPermission() async {
    _setLoading(true);

    try {
      _lastResult = await _requestLocationPermissionUseCase.execute();
      _hasPermission = _lastResult == LocationPermissionResult.granted;

      debugPrint('✅ Resultado da permissão: $_lastResult');
      return _lastResult!;
    } catch (e) {
      debugPrint('❌ Erro ao solicitar permissão: $e');
      _lastResult = LocationPermissionResult.denied;
      return _lastResult!;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> openSettings() async {
    try {
      await _repository.openSettings();
      debugPrint('✅ Configurações abertas');
    } catch (e) {
      debugPrint('❌ Erro ao abrir configurações: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
