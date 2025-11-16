// domain/usecases/user/add_favorite_place_usecase.dart

import '../../repositories/user_repository_protocol.dart';

class AddFavoritePlaceUseCase {
  final UserRepositoryProtocol _userRepository;

  AddFavoritePlaceUseCase(this._userRepository);

  Future<void> execute({
    required String userId,
    required String placeId,
  }) async {
    try {
      if (userId.trim().isEmpty || placeId.trim().isEmpty) {
        throw Exception('User ID e Place ID são obrigatórios');
      }

      await _userRepository.addFavorite(userId, placeId);
    } catch (e) {
      print('❌ Erro ao adicionar favorito: $e');
      rethrow;
    }
  }
}
