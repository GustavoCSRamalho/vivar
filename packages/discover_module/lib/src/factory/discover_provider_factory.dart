// presentation/providers/discover_provider_factory.dart

import 'package:discover_module/src/data/datasource/discover_datasource.dart';
import 'package:discover_module/src/data/repositories/discover_repository_impl.dart';
import 'package:discover_module/src/presentation/providers/discover_provider.dart';

import '../domain/usecases/get_collection_places_usecase.dart';
import '../domain/usecases/get_near_you_places_usecase.dart';
import '../domain/usecases/get_top_rated_places_usecase.dart';
import '../domain/usecases/get_trending_places_usecase.dart';
import '../domain/usecases/get_collections_usecase.dart';

class DiscoverProviderFactory {
  static DiscoverProvider create() {
    final datasource = DiscoverDatasourceImpl();
    final repository = DiscoverRepositoryImpl(datasource: datasource);

    final getCollectionsUseCase = GetCollectionsUseCase(repository);
    final getCollectionBusinessesUseCase = GetCollectionBusinessesUseCase(
      repository,
    );
    final getTrendingBusinessesUseCase = GetTrendingBusinessesUseCase(
      repository,
    );
    final getNearYouBusinessesUseCase = GetNearYouBusinessesUseCase(repository);
    final getTopRatedBusinessesUseCase = GetTopRatedBusinessesUseCase(
      repository,
    );

    return DiscoverProvider(
      getCollectionsUseCase: getCollectionsUseCase,
      getCollectionBusinessesUseCase: getCollectionBusinessesUseCase,
      getTrendingBusinessesUseCase: getTrendingBusinessesUseCase,
      getNearYouBusinessesUseCase: getNearYouBusinessesUseCase,
      getTopRatedBusinessesUseCase: getTopRatedBusinessesUseCase,
    );
  }
}
