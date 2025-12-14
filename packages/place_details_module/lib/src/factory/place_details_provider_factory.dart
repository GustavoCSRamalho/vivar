// presentation/providers/place_details_provider_factory.dart

import 'package:place_details_module/src/data/datasource/place_details_datasource.dart';
import 'package:place_details_module/src/data/datasource/place_details_remote_datasource_impl.dart';
import 'package:place_details_module/src/data/datasource/place_details_sync_datasource.dart';
import 'package:place_details_module/src/data/datasource/user/home_user_datasource.dart';
import 'package:place_details_module/src/data/datasource/user/home_user_remote_datasource_impl.dart';
import 'package:place_details_module/src/data/datasource/user/home_user_sync_datasource.dart';
import 'package:place_details_module/src/data/repositories/place_details_repository_impl.dart';
import 'package:place_details_module/src/data/repositories/user_repository_impl.dart';
import 'package:place_details_module/src/domain/usecase/add_review_usecase.dart';
import 'package:place_details_module/src/domain/usecase/check_user_reviewed_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_current_user_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_by_Id_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_details_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_reviews_usecase.dart';
import 'package:place_details_module/src/domain/usecase/load_user_favorites_usecase.dart';
import 'package:place_details_module/src/domain/usecase/toggle_favorite_place_usecase.dart';
import 'package:place_details_module/src/presentation/providers/place_details_provider.dart';

class PlaceDetailsProviderFactory {
  static PlaceDetailsProvider create() {
    final datasource = PlaceDetailsDatasource();
    final remoteDataSource = PlaceDetailsRemoteDatasourceImpl();
    final syncDataSource = PlaceDetailsSyncDatasource(
      localDatasource: datasource,
      remoteDatasource: remoteDataSource,
    );
    final repository = PlaceDetailsRepositoryImpl(
      syncDatasource: syncDataSource,
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

    final getPlaceDetailsUseCase = GetPlaceDetailsUseCase(repository);
    final getPlaceReviewsUseCase = GetPlaceReviewsUseCase(repository);
    final addReviewUseCase = AddReviewUseCase(repository);
    final checkUserReviewedUseCase = CheckUserReviewedUseCase(repository);
    final getPlaceByIdUseCase = GetPlaceByIdUseCase(repository);
    final toggleFavoriteBusinessesUseCase = ToggleFavoriteBusinessesUseCase(
      userRepositoryImpl,
    );
    final loadUserFavoritesUseCase = LoadUserFavoritesUseCase(
      userRepositoryImpl,
    );
    final getCurrentUserUseCase = GetCurrentUserUseCase(userRepositoryImpl);

    return PlaceDetailsProvider(
      getPlaceDetailsUseCase: getPlaceDetailsUseCase,
      getPlaceReviewsUseCase: getPlaceReviewsUseCase,
      addReviewUseCase: addReviewUseCase,
      checkUserReviewedUseCase: checkUserReviewedUseCase,
      getPlaceByIdUseCase: getPlaceByIdUseCase,
      toggleFavoriteBusinessesUseCase: toggleFavoriteBusinessesUseCase,
      loadUserFavoritesUseCase: loadUserFavoritesUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
    );
  }
}
