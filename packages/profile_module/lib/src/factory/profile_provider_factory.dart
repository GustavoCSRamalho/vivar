// presentation/providers/profile_provider_factory.dart

import '../domain/usecases/get_recent_checkins_count_usecase.dart';
import '../data/datasource/profile/profile_local_datasource.dart';
import '../data/datasource/profile/profile_remote_datasource_impl.dart';
import '../data/datasource/profile/profile_sync_datasource.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/usecases/get_profile_usecase.dart';
import '../domain/usecases/get_recent_badges_usecase.dart';
import '../domain/usecases/update_profile_usecase.dart';
import '../presentation/providers/profile_provider.dart';

class ProfileProviderFactory {
  static ProfileProvider create() {
    final datasource = ProfileLocalDataSource();
    final remoteDatasource = ProfileRemoteDatasourceImpl();

    final syncDataSource = ProfileSyncDataSource(
      localDatasource: datasource,
      remoteDatasource: remoteDatasource,
    );
    final profileRepositoryImpl = ProfileRepositoryImpl(
      syncDatasource: syncDataSource,
    );

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
