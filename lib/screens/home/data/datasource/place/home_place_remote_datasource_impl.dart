// data/datasources/place/place_remote_datasource_protocol.dart

import 'dart:math';

import 'package:vivar/models/business_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class BusinessesRemoteDatasourceProtocol {
  Future<List<BusinessModel>> getAllBusinesses();
  Future<BusinessModel?> getBusinessesById(String id);
  Future<Map<String, dynamic>> getSyncData(DateTime? lastSync);
  Future<List<BusinessModel>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
}

// data/datasources/place/place_remote_datasource_impl.dart

class BusinessesRemoteDatasourceImpl
    implements BusinessesRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  BusinessesRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<List<BusinessModel>> getAllBusinesses() async {
    try {
      final response = await _supabase.from('businesses').select();

      return (response as List)
          .map((data) => BusinessModel.fromMap(data))
          .toList();
    } catch (e) {
      print('❌ Erro ao buscar todos os lugares remotos: $e');
      return [];
    }
  }

  @override
  Future<BusinessModel?> getBusinessesById(String id) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return BusinessModel.fromMap(response);
    } catch (e) {
      print('❌ Erro ao buscar lugar remoto por ID: $e');
      return null;
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
      print('❌ Erro ao buscar dados de sincronização: $e');
      return {'businesses': [], 'total': 0};
    }
  }

  @override
  Future<List<BusinessModel>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      // Opção 1: Buscar todos e filtrar localmente (como estava no Firebase)
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
      // Opção 2: Usar PostGIS do PostgreSQL para busca geoespacial (MAIS EFICIENTE)
      // Requer que a tabela businesses tenha uma coluna geography(Point, 4326)
      // e um índice GIST criado nela
      
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
      print('❌ Erro ao buscar lugares próximos remotos: $e');
      return [];
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
