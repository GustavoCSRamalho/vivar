// data/datasources/place/place_details_remote_datasource_protocol.dart

import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/models/review_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PlaceDetailsRemoteDatasourceProtocol {
  Future<BusinessModel?> getPlaceById(String placeId);
  Future<List<Map<String, dynamic>>> getPlaceReviews(String placeId);
  Future<void> addReview(ReviewModel review);
  Future<Map<String, dynamic>> getSyncData(String placeId, DateTime? lastSync);
}

// data/datasources/place/place_details_remote_datasource_impl.dart

class PlaceDetailsRemoteDatasourceImpl
    implements PlaceDetailsRemoteDatasourceProtocol {
  final SupabaseClient _supabase;

  PlaceDetailsRemoteDatasourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<BusinessModel?> getPlaceById(String placeId) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select()
          .eq('id', placeId)
          .maybeSingle();

      if (response == null) return null;
      return BusinessModel.fromMap(response);
    } catch (e) {
      print('❌ Erro ao buscar detalhes do lugar remoto: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPlaceReviews(String placeId) async {
    try {
      // Opção 1: Fazer JOIN usando Supabase (RECOMENDADO)
      final response = await _supabase
          .from('reviews')
          .select('''
          *,
          users!reviews_user_id_fkey (
            name,
            avatar_url
          )
        ''')
          .eq('place_id', placeId)
          .order('created_at', ascending: false);

      return (response as List).map((review) {
        final user = review['users'];
        final Map<String, dynamic> reviewMap = Map<String, dynamic>.from(
          review,
        );
        reviewMap['user_name'] = user?['name'];
        reviewMap['user_avatar_url'] = user?['avatar_url'];
        reviewMap.remove('users'); // Remove o objeto user aninhado
        return reviewMap;
      }).toList();

      /* 
    // Opção 2: Fazer queries separadas (menos eficiente)
    final reviewsResponse = await _supabase
        .from('reviews')
        .select()
        .eq('place_id', placeId)
        .order('created_at', ascending: false);

    final reviews = <Map<String, dynamic>>[];

    for (final reviewData in (reviewsResponse as List)) {
      final userId = reviewData['user_id'] as String;

      final userResponse = await _supabase
          .from('users')
          .select('name, avatar_url')
          .eq('id', userId)
          .maybeSingle();

      reviews.add({
        ...Map<String, dynamic>.from(reviewData),
        'user_name': userResponse?['name'],
        'user_avatar_url': userResponse?['avatar_url'],
      });
    }

    return reviews;
    */
    } catch (e) {
      print('❌ Erro ao buscar reviews remotas: $e');
      return [];
    }
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    try {
      await _supabase.from('reviews').insert(review.toMap());
    } catch (e) {
      print('❌ Erro ao adicionar review remota: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getSyncData(
    String placeId,
    DateTime? lastSync,
  ) async {
    try {
      // Query para place
      var placeQuery = _supabase.from('businesses').select().eq('id', placeId);

      if (lastSync != null) {
        placeQuery = placeQuery.gt('updated_at', lastSync.toIso8601String());
      }

      // Query para reviews com JOIN de users
      var reviewsQuery = _supabase
          .from('reviews')
          .select('''
            *,
            users!reviews_user_id_fkey (
              name,
              avatar_url
            )
          ''')
          .eq('place_id', placeId);

      if (lastSync != null) {
        reviewsQuery = reviewsQuery.gt(
          'updated_at',
          lastSync.toIso8601String(),
        );
      }

      final placeResponse = await placeQuery.maybeSingle();
      final reviewsResponse = await reviewsQuery;

      final reviews = (reviewsResponse as List).map((review) {
        final user = review['users'];
        final Map<String, dynamic> reviewMap = Map<String, dynamic>.from(
          review,
        );
        reviewMap['user_name'] = user?['name'];
        reviewMap['user_avatar_url'] = user?['avatar_url'];
        reviewMap.remove('users');
        return reviewMap;
      }).toList();
      return {'place': placeResponse, 'reviews': reviews};
    } catch (e) {
      print('❌ Erro ao buscar dados de sincronização de detalhes: $e');
      return {'place': null, 'reviews': []};
    }
  }
}
