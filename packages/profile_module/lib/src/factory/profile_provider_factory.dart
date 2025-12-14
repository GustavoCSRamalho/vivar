// presentation/providers/profile_provider_factory.dart

import 'package:profile_module/src/data/datasource/user/home_user_datasource.dart';
import 'package:profile_module/src/data/datasource/user/home_user_remote_datasource_impl.dart';
import 'package:profile_module/src/data/datasource/user/home_user_sync_datasource.dart';
import 'package:profile_module/src/data/repositories/user_repository_impl.dart';
import 'package:profile_module/src/domain/usecases/get_current_user_usecase.dart';

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

    final userDataSource = UserDatasourceImpl();
    final userRemoteDataSource = UserRemoteDatasourceImpl();
    final syncUserDataSource = UserSyncDatasource(
      localDatasource: userDataSource,
      remoteDatasource: userRemoteDataSource,
    );
    final userRepositoryImpl = UserRepositoryImpl(
      syncDatasource: syncUserDataSource,
    );

    final getProfileUseCase = GetProfileUseCase(profileRepositoryImpl);
    final updateProfileUseCase = UpdateProfileUseCase(profileRepositoryImpl);
    final getRecentCheckinsCountUseCase = GetRecentCheckinsCountUseCase(
      profileRepositoryImpl,
    );
    final getRecentBadgesUseCase = GetRecentBadgesUseCase(
      profileRepositoryImpl,
    );
    final getCurrentUserUseCase = GetCurrentUserUseCase(userRepositoryImpl);

    return ProfileProvider(
      getProfileUseCase: getProfileUseCase,
      updateProfileUseCase: updateProfileUseCase,
      getRecentCheckinsCountUseCase: getRecentCheckinsCountUseCase,
      getRecentBadgesUseCase: getRecentBadgesUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
    );
  }
}
