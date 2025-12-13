// presentation/providers/home_provider_factory.dart

import '../data/service/location_service.dart';
import '../domain/usecases/apply_advanced_filters_usecase.dart';
import '../domain/usecases/filter_places_by_category_usecase.dart';
import '../domain/usecases/get_all_businesses_usecase.dart';
import '../domain/usecases/get_nearby_places_usecase.dart';
import '../domain/usecases/search_places_usecase.dart';
import '../domain/usecases/toggle_favorite_place_usecase.dart';
import '../data/datasource/location_datasource.dart';
import '../data/datasource/notification_datasource.dart';
import '../data/datasource/place/home_place_datasource.dart';
import '../data/datasource/place/home_place_remote_datasource_impl.dart';
import '../data/datasource/place/home_place_sync_datasource.dart';
import '../data/datasource/user/home_user_datasource.dart';
import '../data/datasource/user/home_user_remote_datasource_impl.dart';
import '../data/datasource/user/home_user_sync_datasource.dart';
import '../data/repositories/location_repository_impl.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../data/repositories/place_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/usecases/get_current_location_usecase.dart';
import '../domain/usecases/check_unread_notifications_usecase.dart';
import '../domain/usecases/get_notifications_usecase.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/load_user_favorites_usecase.dart';
import '../presentation/providers/home_provider.dart';

class HomeProviderFactory {
  static HomeProvider create() {
    final locationService = LocationService();

    // Repository Implementations
    final BusinessesDatasource = BusinessesDatasourceImpl();
    final userDatasource = UserDatasourceImpl();
    final locationDatasource = LocationDatasourceImpl();
    final notificationDatasource = NotificationDatasource();

    // No seu DI container ou GetIt
    final remoteDatasource = BusinessesRemoteDatasourceImpl();

    final syncDatasource = BusinessesSyncDatasource(
      localDatasource: BusinessesDatasource,
      remoteDatasource: remoteDatasource,
    );

    final businessesRepositoryImpl = BusinessesRepositoryImpl(
      syncDatasource: syncDatasource,
    );

    final userDataSource = UserDatasourceImpl();
    final userRemoteDataSource = UserRemoteDatasourceImpl();
    final syncUserDataSource = UserSyncDatasource(
      localDatasource: userDataSource,
      remoteDatasource: userRemoteDataSource,
    );
    final userRepositoryImpl = UserRepositoryImpl(
      syncDatasource: syncUserDataSource,
    );
    final locationRepositoryImpl = LocationRepositoryImpl(
      datasource: locationDatasource,
    );
    final notificationRepositoryImpl = NotificationRepositoryImpl(
      datasource: notificationDatasource,
    );

    // Use Cases
    final getCurrentLocationUseCase = GetCurrentLocationUseCase(
      locationService,
      locationRepositoryImpl,
    );
    final getAllBusinessessUseCase = GetAllBusinessesUseCase(
      businessesRepositoryImpl,
    );
    final getNearbyBusinessessUseCase = GetNearbyBusinessesUseCase(
      businessesRepositoryImpl,
      locationService,
    );
    final filterBusinessessByCategoryUseCase =
        FilterBusinessesByCategoryUseCase();
    final applyAdvancedFiltersUseCase = ApplyAdvancedFiltersUseCase(
      businessesRepositoryImpl,
    );
    final searchBusinessessUseCase = SearchBusinessesUseCase(
      businessesRepositoryImpl,
    );
    final getCurrentUserUseCase = GetCurrentUserUseCase(userRepositoryImpl);
    final loadUserFavoritesUseCase = LoadUserFavoritesUseCase(
      userRepositoryImpl,
    );
    final toggleFavoriteBusinessesUseCase = ToggleFavoriteBusinessesUseCase(
      userRepositoryImpl,
    );
    final getNotificationsUseCase = GetNotificationsUseCase(
      notificationRepositoryImpl,
    );
    final checkUnreadNotificationsUseCase = CheckUnreadNotificationsUseCase(
      notificationRepositoryImpl,
    );

    // HomeProvider
    return HomeProvider(
      getCurrentLocationUseCase: getCurrentLocationUseCase,
      getAllBusinessesUseCase: getAllBusinessessUseCase,
      getNearbyBusinessesUseCase: getNearbyBusinessessUseCase,
      filterBusinessesByCategoryUseCase: filterBusinessessByCategoryUseCase,
      searchBusinessesUseCase: searchBusinessessUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      loadUserFavoritesUseCase: loadUserFavoritesUseCase,
      toggleFavoriteBusinessesUseCase: toggleFavoriteBusinessesUseCase,
      getNotificationsUseCase: getNotificationsUseCase,
      checkUnreadNotificationsUseCase: checkUnreadNotificationsUseCase,
      applyAdvancedFiltersUseCase: applyAdvancedFiltersUseCase,
    );
  }
}
