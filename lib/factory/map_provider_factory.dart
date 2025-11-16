// presentation/providers/map_provider_factory.dart

import 'package:vivar/screens/map/data/repositories/map_repository_impl.dart';
import 'package:vivar/screens/map/domain/usecases/map/get_nearby_places_for_map_usecase.dart';
import 'package:vivar/screens/map/domain/usecases/map/get_places_by_category_usecase.dart';
import 'package:vivar/screens/map/domain/usecases/map/get_places_for_map_usecase.dart';
import 'package:vivar/screens/map/domain/usecases/map/search_places_on_map_usecase.dart';
import 'package:vivar/screens/map/presentation/providers/map_provider.dart';

class MapProviderFactory {
  static MapProvider create() {
    final mapRepositoryImpl = MapRepositoryImpl();

    final getPlacesForMapUseCase = GetPlacesForMapUseCase(mapRepositoryImpl);
    final getPlacesByCategoryUseCase = GetPlacesByCategoryUseCase(
      mapRepositoryImpl,
    );
    final getNearbyPlacesForMapUseCase = GetNearbyPlacesForMapUseCase(
      mapRepositoryImpl,
    );
    final searchPlacesOnMapUseCase = SearchPlacesOnMapUseCase(
      mapRepositoryImpl,
    );

    return MapProvider(
      getPlacesForMapUseCase: getPlacesForMapUseCase,
      getPlacesByCategoryUseCase: getPlacesByCategoryUseCase,
      getNearbyPlacesForMapUseCase: getNearbyPlacesForMapUseCase,
      searchPlacesOnMapUseCase: searchPlacesOnMapUseCase,
    );
  }
}
