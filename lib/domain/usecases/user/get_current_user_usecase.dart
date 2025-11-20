// domain/usecases/user/get_current_user_usecase.dart

import '../../entity/user/user_entity.dart';
import '../../interface/user/user_repository_protocol.dart';

class GetCurrentUserUseCase {
  final UserRepositoryProtocol _userRepository;

  GetCurrentUserUseCase(this._userRepository);

  Future<UserEntity?> execute() async {
    try {
      return await _userRepository.getCurrentUser();
    } catch (e) {
      print('❌ Erro ao buscar usuário atual: $e');
      return null;
    }
  }
}
