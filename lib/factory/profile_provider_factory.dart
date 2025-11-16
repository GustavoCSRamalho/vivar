// presentation/providers/profile_provider_factory.dart

import 'package:vivar/screens/auth/data/repositories/profile_repository_impl.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/get_profile_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/get_recent_badges_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/get_recent_checkins_count_usecase.dart';
import 'package:vivar/screens/auth/domain/usecases/profile/update_profile_usecase.dart';
import '../screens/auth/presentation/providers/profile_provider.dart';

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
