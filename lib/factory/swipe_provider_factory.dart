// presentation/providers/swipe_provider_factory.dart

import 'package:vivar/domain/usecases/swipe/dislike_place_usecase.dart';
import 'package:vivar/domain/usecases/swipe/get_swipe_places_usecase.dart';
import 'package:vivar/domain/usecases/swipe/like_place_usecase.dart';
import 'package:vivar/domain/usecases/swipe/super_like_place_usecase.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_local_datasource.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_remote_datasource_impl.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_sync_service.dart';
import 'package:vivar/screens/swipe/data/repositories/swipe_repository_impl.dart';
import 'package:vivar/screens/swipe/presentation/providers/swipe_provider.dart';

class SwipeProviderFactory {
  static SwipeProvider create() {
    final localDataSource = SwipeLocalDataSource();
    final remoteDataSource = SwipeRemoteDatasourceImpl();

    final syncService = SwipeSyncService(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );

    final repository = SwipeRepositoryImpl(syncService: syncService);

    final getSwipeBusinessesUseCase = GetSwipeBusinessesUseCase(repository);
    final likePlaceUseCase = LikeBusinessesUseCase(repository);
    final dislikePlaceUseCase = DislikeBusinessesUseCase(repository);
    final superLikePlaceUseCase = SuperLikeBusinessesUseCase(repository);

    return SwipeProvider(
      getSwipeBusinessesUseCase: getSwipeBusinessesUseCase,
      likeBusinessesUseCase: likePlaceUseCase,
      dislikeBusinessesUseCase: dislikePlaceUseCase,
      superLikeBusinessesUseCase: superLikePlaceUseCase,
    );
  }
}
