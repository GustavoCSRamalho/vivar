// domain/usecases/user/toggle_favorite_place_usecase.dart

import '../../repositories/user_repository_protocol.dart';

class ToggleFavoritePlaceUseCase {
  final UserRepositoryProtocol _userRepository;

  ToggleFavoritePlaceUseCase(this._userRepository);

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
