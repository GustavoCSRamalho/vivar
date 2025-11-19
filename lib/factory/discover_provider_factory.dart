// presentation/providers/discover_provider_factory.dart

import 'package:vivar/screens/discover/data/repositories/discover_repository_impl.dart';
import 'package:vivar/domain/usecases/discover/get_collection_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_collections_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_near_you_places_usecase.dart';
import 'package:vivar/domain/usecases/discover/get_trending_places_usecase.dart';
import 'package:vivar/screens/discover/presentation/providers/discover_provider.dart';
import 'package:vivar/screens/home/data/repositories/place_repository_impl.dart';
import 'package:vivar/domain/usecases/place/get_top_rated_places_usecase.dart';
import 'package:vivar/screens/place_details/data/repositories/place_details_repository_impl.dart';

class DiscoverProviderFactory {
  static DiscoverProvider create() {
    final repository = DiscoverRepositoryImpl();
    final placeRepository = PlaceRepositoryImpl();

    final getCollectionsUseCase = GetCollectionsUseCase(repository);
    final getCollectionPlacesUseCase = GetCollectionPlacesUseCase(repository);
    final getTrendingPlacesUseCase = GetTrendingPlacesUseCase(repository);
    final getNearYouPlacesUseCase = GetNearYouPlacesUseCase(repository);
    final getTopRatedPlacesUseCase = GetTopRatedPlacesUseCase(placeRepository);

    return DiscoverProvider(
      getCollectionsUseCase: getCollectionsUseCase,
      getCollectionPlacesUseCase: getCollectionPlacesUseCase,
      getTrendingPlacesUseCase: getTrendingPlacesUseCase,
      getNearYouPlacesUseCase: getNearYouPlacesUseCase,
      getTopRatedPlacesUseCase: getTopRatedPlacesUseCase,
    );
  }
}
