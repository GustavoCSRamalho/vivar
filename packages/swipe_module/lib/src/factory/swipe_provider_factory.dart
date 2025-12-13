// presentation/providers/swipe_provider_factory.dart;

import 'package:swipe_module/src/domain/usecases/dislike_place_usecase.dart';
import 'package:swipe_module/src/domain/usecases/get_swipe_places_usecase.dart';
import 'package:swipe_module/src/domain/usecases/like_place_usecase.dart';
import 'package:swipe_module/src/domain/usecases/super_like_place_usecase.dart';

import '../data/datasource/swipe_local_datasource.dart';
import '../data/datasource/swipe_remote_datasource_impl.dart';
import '../data/datasource/swipe_sync_service.dart';
import '../data/repositories/swipe_repository_impl.dart';
import '../presentation/providers/swipe_provider.dart';

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
