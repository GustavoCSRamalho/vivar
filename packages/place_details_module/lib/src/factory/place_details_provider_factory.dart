// presentation/providers/place_details_provider_factory.dart

import 'package:place_details_module/src/data/datasource/place_details_datasource.dart';
import 'package:place_details_module/src/data/datasource/place_details_remote_datasource_impl.dart';
import 'package:place_details_module/src/data/datasource/place_details_sync_datasource.dart';
import 'package:place_details_module/src/data/repositories/place_details_repository_impl.dart';
import 'package:place_details_module/src/domain/usecase/add_review_usecase.dart';
import 'package:place_details_module/src/domain/usecase/check_user_reviewed_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_by_Id_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_details_usecase.dart';
import 'package:place_details_module/src/domain/usecase/get_place_reviews_usecase.dart';
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

    final getPlaceDetailsUseCase = GetPlaceDetailsUseCase(repository);
    final getPlaceReviewsUseCase = GetPlaceReviewsUseCase(repository);
    final addReviewUseCase = AddReviewUseCase(repository);
    final checkUserReviewedUseCase = CheckUserReviewedUseCase(repository);
    final getPlaceByIdUseCase = GetPlaceByIdUseCase(repository);

    return PlaceDetailsProvider(
      getPlaceDetailsUseCase: getPlaceDetailsUseCase,
      getPlaceReviewsUseCase: getPlaceReviewsUseCase,
      addReviewUseCase: addReviewUseCase,
      checkUserReviewedUseCase: checkUserReviewedUseCase,
      getPlaceByIdUseCase: getPlaceByIdUseCase,
    );
  }
}
