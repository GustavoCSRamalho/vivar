// presentation/providers/discover_provider_factory.dart

import 'package:vivar/domain/usecases/discover/get_collection_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_near_you_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_top_rated_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_trending_places_usecase.dart';
import 'package:vivar/screens/discover/data/datasource/discover_datasource.dart';
import 'package:vivar/screens/discover/data/repositories/discover_repository_impl.dart';
import 'package:vivar/domain/usecases/discover/get_collections_usecase.dart';
import 'package:vivar/screens/discover/presentation/providers/discover_provider.dart';

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
