// presentation/providers/place_details_provider_factory.dart

import 'package:vivar/screens/place_details/data/repositories/place_details_repository_impl.dart';
import 'package:vivar/domain/usecases/place_details/add_review_usecase.dart';
import 'package:vivar/domain/usecases/place_details/check_user_reviewed_usecase.dart';
import 'package:vivar/domain/usecases/place_details/get_place_by_Id_usecase.dart';
import 'package:vivar/domain/usecases/place_details/get_place_details_usecase.dart';
import 'package:vivar/domain/usecases/place_details/get_place_reviews_usecase.dart';
import '../screens/place_details/presentation/providers/place_details_provider.dart';

class PlaceDetailsProviderFactory {
  static PlaceDetailsProvider create() {
    final repository = PlaceDetailsRepositoryImpl();

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
