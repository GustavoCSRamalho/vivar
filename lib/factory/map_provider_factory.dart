// presentation/providers/map_provider_factory.dart

import 'package:vivar/domain/usecases/map/get_nearby_places_for_map_usecase.dart';
import 'package:vivar/domain/usecases/map/get_places_by_category_usecase.dart';
import 'package:vivar/domain/usecases/map/get_places_for_map_usecase.dart';
import 'package:vivar/domain/usecases/map/search_places_on_map_usecase.dart';
import 'package:vivar/screens/map/data/datasource/map_datasource.dart';
import 'package:vivar/screens/map/data/datasource/map_remote_datasource_impl.dart';
import 'package:vivar/screens/map/data/datasource/map_sync_datasource.dart';
import 'package:vivar/screens/map/data/repositories/map_repository_impl.dart';
import 'package:vivar/screens/map/presentation/providers/map_provider.dart';

class MapProviderFactory {
  static MapProvider create() {
    final datasource = MapDatasourceImpl();
    final remoteDatasource = MapRemoteDatasourceImpl();
    final syncDatasource = MapSyncDatasource(
      localDatasource: datasource,
      remoteDatasource: remoteDatasource,
    );
    final mapRepositoryImpl = MapRepositoryImpl(syncDatasource: syncDatasource);

    final getBusinessesForMapUseCase = GetBusinessesForMapUseCase(
      mapRepositoryImpl,
    );
    final getBusinessesByCategoryUseCase = GetBusinessesByCategoryUseCase(
      mapRepositoryImpl,
    );
    final getNearbyBusinessesForMapUseCase = GetNearbyBusinessesForMapUseCase(
      mapRepositoryImpl,
    );
    final searchBusinessesOnMapUseCase = SearchBusinessesOnMapUseCase(
      mapRepositoryImpl,
    );

    return MapProvider(
      getBusinessesForMapUseCase: getBusinessesForMapUseCase,
      getBusinessesByCategoryUseCase: getBusinessesByCategoryUseCase,
      getNearbyBusinessesForMapUseCase: getNearbyBusinessesForMapUseCase,
      searchBusinessesOnMapUseCase: searchBusinessesOnMapUseCase,
    );
  }
}
