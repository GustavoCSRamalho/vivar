// domain/repositories/discover_repository_protocol.dart

import 'package:discover_module/src/domain/entity/business_entity.dart';
import 'package:discover_module/src/domain/entity/discover_collection_entity.dart';

abstract class DiscoverRepositoryProtocol {
  Future<List<DiscoverCollectionEntity>> getCollections();
  Future<List<BusinessEntity>> getCollectionBusinesses(String collectionId);
  Future<List<BusinessEntity>> getTrendingBusinesses();
  Future<List<BusinessEntity>> getNearYouBusinesses();
  Future<List<BusinessEntity>> getTopRatedBusinesses();
}
