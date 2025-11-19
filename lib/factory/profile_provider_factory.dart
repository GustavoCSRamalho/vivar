// presentation/providers/profile_provider_factory.dart

import 'package:vivar/domain/usecases/profile/get_recent_checkins_count_usecase.dart';
import 'package:vivar/screens/profile/data/repositories/profile_repository_impl.dart';
import '../domain/usecases/profile/get_profile_usecase.dart';
import '../domain/usecases/profile/get_recent_badges_usecase.dart';
import '../domain/usecases/profile/update_profile_usecase.dart';
import '../screens/profile/presentation/providers/profile_provider.dart';

class ProfileProviderFactory {
  static ProfileProvider create() {
    final profileRepositoryImpl = ProfileRepositoryImpl();

    final getProfileUseCase = GetProfileUseCase(profileRepositoryImpl);
    final updateProfileUseCase = UpdateProfileUseCase(profileRepositoryImpl);
    final getRecentCheckinsCountUseCase = GetRecentCheckinsCountUseCase(
      profileRepositoryImpl,
    );
    final getRecentBadgesUseCase = GetRecentBadgesUseCase(
      profileRepositoryImpl,
    );

    return ProfileProvider(
      getProfileUseCase: getProfileUseCase,
      updateProfileUseCase: updateProfileUseCase,
      getRecentCheckinsCountUseCase: getRecentCheckinsCountUseCase,
      getRecentBadgesUseCase: getRecentBadgesUseCase,
    );
  }
}
