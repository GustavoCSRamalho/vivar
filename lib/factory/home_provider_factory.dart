// presentation/providers/home_provider_factory.dart

import 'package:vivar/core/repositories/favorite_repository.dart';
import 'package:vivar/core/repositories/notification_repository.dart';
import 'package:vivar/core/repositories/place_repository.dart';
import 'package:vivar/core/repositories/user_repository.dart';
import 'package:vivar/core/services/location_service.dart';
import 'package:vivar/screens/home/data/datasource/location_datasource.dart';
import 'package:vivar/screens/home/data/datasource/notification_datasource.dart';
import 'package:vivar/screens/home/data/datasource/place_datasource.dart';
import 'package:vivar/screens/home/data/datasource/user_datasource.dart';
import 'package:vivar/screens/home/data/repositories/location_repository_impl.dart';
import 'package:vivar/screens/home/data/repositories/notification_repository_impl.dart';
import 'package:vivar/screens/home/data/repositories/place_repository_impl.dart';
import 'package:vivar/screens/home/data/repositories/user_repository_impl.dart';
import 'package:vivar/domain/usecases/location/get_current_location_usecase.dart';
import 'package:vivar/domain/usecases/notification/check_unread_notifications_usecase.dart';
import 'package:vivar/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:vivar/domain/usecases/place/filter_places_by_category_usecase.dart';
import 'package:vivar/domain/usecases/place/get_all_places_usecase.dart';
import 'package:vivar/domain/usecases/place/get_nearby_places_usecase.dart';
import 'package:vivar/domain/usecases/place/search_places_usecase.dart';
import 'package:vivar/domain/usecases/user/get_current_user_usecase.dart';
import 'package:vivar/domain/usecases/user/load_user_favorites_usecase.dart';
import 'package:vivar/domain/usecases/user/toggle_favorite_place_usecase.dart';
import 'package:vivar/screens/home/presentation/providers/home_provider.dart';

import '../domain/usecases/place/apply_advanced_filters_usecase.dart';

class HomeProviderFactory {
  static HomeProvider create() {
    final locationService = LocationService();

    // Repository Implementations
    final placeDatasource = PlaceDatasourceImpl();
    final userDatasource = UserDatasourceImpl();
    final locationDatasource = LocationDatasourceImpl();
    final notificationDatasource = NotificationDatasource();

    final placeRepositoryImpl = PlaceRepositoryImpl(
      datasource: placeDatasource,
    );
    final userRepositoryImpl = UserRepositoryImpl(datasource: userDatasource);
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
    final getAllPlacesUseCase = GetAllPlacesUseCase(placeRepositoryImpl);
    final getNearbyPlacesUseCase = GetNearbyPlacesUseCase(
      placeRepositoryImpl,
      locationService,
    );
    final filterPlacesByCategoryUseCase = FilterPlacesByCategoryUseCase();
    final applyAdvancedFiltersUseCase = ApplyAdvancedFiltersUseCase(
      placeRepositoryImpl,
    );
    final searchPlacesUseCase = SearchPlacesUseCase(placeRepositoryImpl);
    final getCurrentUserUseCase = GetCurrentUserUseCase(userRepositoryImpl);
    final loadUserFavoritesUseCase = LoadUserFavoritesUseCase(
      userRepositoryImpl,
    );
    final toggleFavoritePlaceUseCase = ToggleFavoritePlaceUseCase(
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
      getAllPlacesUseCase: getAllPlacesUseCase,
      getNearbyPlacesUseCase: getNearbyPlacesUseCase,
      filterPlacesByCategoryUseCase: filterPlacesByCategoryUseCase,
      searchPlacesUseCase: searchPlacesUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      loadUserFavoritesUseCase: loadUserFavoritesUseCase,
      toggleFavoritePlaceUseCase: toggleFavoritePlaceUseCase,
      getNotificationsUseCase: getNotificationsUseCase,
      checkUnreadNotificationsUseCase: checkUnreadNotificationsUseCase,
      applyAdvancedFiltersUseCase: applyAdvancedFiltersUseCase,
    );
  }
}
