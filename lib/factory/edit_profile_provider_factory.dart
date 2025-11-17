// presentation/providers/edit_profile_provider_factory.dart

import 'package:vivar/screens/profile/data/repositories/profile_repository_impl.dart';
import 'package:vivar/screens/profile/data/repositories/user_profile_repository_impl.dart';
import 'package:vivar/screens/profile/domain/usecases/profile/get_profile_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/profile/remove_avatar_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/profile/update_user_profile_usecase.dart';
import 'package:vivar/screens/profile/domain/usecases/profile/upload_avatar_usecase.dart';
import 'package:vivar/screens/profile/presentation/providers/edit_profile_provider.dart';

class EditProfileProviderFactory {
  static EditProfileProvider create() {
    final profileRepository = ProfileRepositoryImpl();
    final userProfileRepository = UserProfileRepositoryImpl();

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
