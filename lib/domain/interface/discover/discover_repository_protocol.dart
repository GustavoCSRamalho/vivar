// domain/repositories/discover_repository_protocol.dart

import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/place/place_entity.dart';
import 'package:vivar/models/business_model.dart';

import '../../entity/discover/discover_collection_entity.dart';

abstract class DiscoverRepositoryProtocol {
  Future<List<DiscoverCollectionEntity>> getCollections();
  Future<List<BusinessEntity>> getCollectionPlaces(String collectionId);
  Future<List<BusinessEntity>> getTrendingPlaces();
  Future<List<BusinessEntity>> getNearYouPlaces();
  Future<List<BusinessEntity>> getTopRatedPlaces();
}
