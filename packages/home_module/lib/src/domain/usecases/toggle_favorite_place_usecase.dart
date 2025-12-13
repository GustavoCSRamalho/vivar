// domain/usecases/user/toggle_favorite_place_usecase.dart

import '../interfaces/user_repository_protocol.dart';

class ToggleFavoriteBusinessesUseCase {
  final UserRepositoryProtocol _userRepository;

  ToggleFavoriteBusinessesUseCase(this._userRepository);

  Future<bool> execute({
    required String userId,
    required String placeId,
  }) async {
    try {
      return await _userRepository.toggleFavorite(userId, placeId);
    } catch (e) {
      print('❌ Erro ao alternar favorito: $e');
      rethrow;
    }
  }
}
