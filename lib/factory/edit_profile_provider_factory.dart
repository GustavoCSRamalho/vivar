// presentation/providers/edit_profile_provider_factory.dart

import '../../packages/profile_module/lib/src/domain/usecases/get_profile_usecase.dart';
import '../../packages/profile_module/lib/src/domain/usecases/remove_avatar_usecase.dart';
import '../../packages/profile_module/lib/src/domain/usecases/update_user_profile_usecase.dart';
import '../../packages/profile_module/lib/src/domain/usecases/upload_avatar_usecase.dart';
import '../../packages/profile_module/lib/src/data/datasource/profile/profile_local_datasource.dart';
import '../../packages/profile_module/lib/src/data/datasource/profile/profile_remote_datasource_impl.dart';
import '../../packages/profile_module/lib/src/data/datasource/profile/profile_sync_datasource.dart';
import '../../packages/profile_module/lib/src/data/datasource/user/profile_user_local_datasource.dart';
import '../../packages/profile_module/lib/src/data/datasource/user/profile_user_local_remote_datasource_impl.dart';
import '../../packages/profile_module/lib/src/data/datasource/user/profile_user_local_sync_datasource.dart';
import '../../packages/profile_module/lib/src/data/repositories/profile_repository_impl.dart';
import '../../packages/profile_module/lib/src/data/repositories/user_profile_repository_impl.dart';
import '../../packages/profile_module/lib/src/presentation/providers/edit_profile_provider.dart';

class EditProfileProviderFactory {
  static EditProfileProvider create() {
    final datasource = ProfileLocalDataSource();
    final remoteDatasource = ProfileRemoteDatasourceImpl();
    final syncDatasource = ProfileSyncDataSource(
      localDatasource: datasource,
      remoteDatasource: remoteDatasource,
    );
    final profileRepository = ProfileRepositoryImpl(
      syncDatasource: syncDatasource,
    );

    final userDatasource = UserLocalDataSourceImpl();
    final remoteUserDatasource = UserLocalRemoteDatasourceImpl();
    final userSyncDatasource = UserLocalSyncDataSource(
      localDatasource: userDatasource,
      remoteDatasource: remoteUserDatasource,
    );
    final userProfileRepository = UserProfileRepositoryImpl(
      syncDatasource: userSyncDatasource,
    );

    final getProfileUseCase = GetProfileUseCase(profileRepository);
    final updateUserProfileUseCase = UpdateUserProfileUseCase(
      userProfileRepository,
    );
    final uploadAvatarUseCase = UploadAvatarUseCase(userProfileRepository);
    final removeAvatarUseCase = RemoveAvatarUseCase(userProfileRepository);

    return EditProfileProvider(
      getProfileUseCase: getProfileUseCase,
      updateUserProfileUseCase: updateUserProfileUseCase,
      uploadAvatarUseCase: uploadAvatarUseCase,
      removeAvatarUseCase: removeAvatarUseCase,
    );
  }
}
