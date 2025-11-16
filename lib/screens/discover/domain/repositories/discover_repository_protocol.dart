// domain/repositories/discover_repository_protocol.dart

import 'package:vivar/screens/home/domain/entities/place_entity.dart';

import '../entities/discover_collection_entity.dart';

abstract class DiscoverRepositoryProtocol {
  Future<List<DiscoverCollectionEntity>> getCollections();
  Future<List<PlaceEntity>> getCollectionPlaces(String collectionId);
  Future<List<PlaceEntity>> getTrendingPlaces();
  Future<List<PlaceEntity>> getNearYouPlaces();
  Future<List<PlaceEntity>> getTopRatedPlaces();
}
