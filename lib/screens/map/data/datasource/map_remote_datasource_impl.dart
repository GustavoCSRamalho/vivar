// data/datasources/map/map_remote_datasource_protocol.dart

import '../../../../../packages/home_module/lib/src/data/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MapRemoteDatasourceProtocol {
  Future<List<BusinessModel>> getBusinessesForMap();
  Future<List<BusinessModel>> getBusinessesByCategory(String category);
  Future<List<BusinessModel>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
  Future<Map<String, dynamic>> getSyncData(DateTime? lastSync);
}

// data/datasources/map/map_remote_datasource_impl.dart

class MapRemoteDatasourceImpl implements MapRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  MapRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<BusinessModel>> getBusinessesForMap() async {
    try {
      final response = await _supabase.from('businesses').select();

      return (response as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();
    } catch (e) {
      print('❌ Erro ao buscar lugares para o mapa remoto: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getBusinessesByCategory(String category) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select()
          .eq('category', category);

      return (response as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();
    } catch (e) {
      print('❌ Erro ao buscar lugares por categoria no mapa remoto: $e');
      return [];
    }
  }

  @override
  Future<List<BusinessModel>> getNearbyBusinessesForMap({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      final response = await _supabase.from('businesses').select();

      final businesses = (response as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();

      return businesses.where((place) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          place.latitude,
          place.longitude,
        );
        return distance <= radiusKm;
      }).toList()..sort((a, b) {
        final distA = _calculateDistance(
          latitude,
          longitude,
          a.latitude,
          a.longitude,
        );
        final distB = _calculateDistance(
          latitude,
          longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });

      /* 
      // Alternativa usando PostGIS (mais eficiente):
      final response = await _supabase.rpc(
        'nearby_businesses',
        params: {
          'lat': latitude,
          'long': longitude,
          'radius_km': radiusKm,
        },
      );

      return (response as List)
          .map((data) => PlaceModel.fromMap(data))
          .toList();
      */
    } catch (e) {
      print('❌ Erro ao buscar lugares próximos no mapa remoto: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getSyncData(DateTime? lastSync) async {
    try {
      var query = _supabase.from('businesses').select();

      if (lastSync != null) {
        query = query.gt('updated_at', lastSync.toIso8601String());
      }

      final response = await query;
      final businesses = response as List;

      return {'businesses': businesses, 'total': businesses.length};
    } catch (e) {
      print('❌ Erro ao buscar dados de sincronização do mapa: $e');
      return {'businesses': [], 'total': 0};
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}
