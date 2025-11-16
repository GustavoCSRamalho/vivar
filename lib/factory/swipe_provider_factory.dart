// presentation/providers/swipe_provider_factory.dart

import 'package:vivar/screens/swipe/data/repositories/swipe_repository_impl.dart';
import 'package:vivar/screens/swipe/domain/usecases/swipe/dislike_place_usecase.dart';
import 'package:vivar/screens/swipe/domain/usecases/swipe/get_swipe_places_usecase.dart';
import 'package:vivar/screens/swipe/domain/usecases/swipe/like_place_usecase.dart';
import 'package:vivar/screens/swipe/domain/usecases/swipe/super_like_place_usecase.dart';
import 'package:vivar/screens/swipe/presentation/providers/swipe_provider.dart';

class SwipeProviderFactory {
  static SwipeProvider create() {
    final repository = SwipeRepositoryImpl();

    final getSwipePlacesUseCase = GetSwipePlacesUseCase(repository);
    final likePlaceUseCase = LikePlaceUseCase(repository);
    final dislikePlaceUseCase = DislikePlaceUseCase(repository);
    final superLikePlaceUseCase = SuperLikePlaceUseCase(repository);

    return SwipeProvider(
      getSwipePlacesUseCase: getSwipePlacesUseCase,
      likePlaceUseCase: likePlaceUseCase,
      dislikePlaceUseCase: dislikePlaceUseCase,
      superLikePlaceUseCase: superLikePlaceUseCase,
    );
  }
}
