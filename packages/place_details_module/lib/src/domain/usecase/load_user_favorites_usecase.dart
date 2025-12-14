// domain/usecases/user/load_user_favorites_usecase.dart

import '../interfaces/user_repository_protocol.dart';

class LoadUserFavoritesUseCase {
  final UserRepositoryProtocol _userRepository;

  LoadUserFavoritesUseCase(this._userRepository);

  Future<List<String>> execute(String userId) async {
    try {
      return await _userRepository.getUserFavoritePlaceIds(userId);
    } catch (e) {
      print('❌ Erro ao carregar favoritos: $e');
      return [];
    }
  }
}
