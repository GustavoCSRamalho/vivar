// presentation/providers/edit_profile_provider_factory.dart

import 'package:vivar/domain/usecases/profile/get_profile_usecase.dart';
import 'package:vivar/domain/usecases/profile/remove_avatar_usecase.dart';
import 'package:vivar/domain/usecases/profile/update_user_profile_usecase.dart';
import 'package:vivar/domain/usecases/profile/upload_avatar_usecase.dart';
import 'package:vivar/screens/profile/data/datasource/profile/profile_local_datasource.dart';
import 'package:vivar/screens/profile/data/datasource/profile/profile_remote_datasource_impl.dart';
import 'package:vivar/screens/profile/data/datasource/profile/profile_sync_datasource.dart';
import 'package:vivar/screens/profile/data/datasource/user/profile_user_local_datasource.dart';
import 'package:vivar/screens/profile/data/datasource/user/profile_user_local_remote_datasource_impl.dart';
import 'package:vivar/screens/profile/data/datasource/user/profile_user_local_sync_datasource.dart';
import 'package:vivar/screens/profile/data/repositories/profile_repository_impl.dart';
import 'package:vivar/screens/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:vivar/screens/profile/presentation/providers/edit_profile_provider.dart';

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
