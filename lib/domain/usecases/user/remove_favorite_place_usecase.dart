// // domain/usecases/user/remove_favorite_place_usecase.dart

// import '../../../../packages/home_module/lib/src/domain/interfaces/user_repository_protocol.dart';

// class RemoveFavoritePlaceUseCase {
//   final UserRepositoryProtocol _userRepository;

//   RemoveFavoritePlaceUseCase(this._userRepository);

//   Future<void> execute({
//     required String userId,
//     required String placeId,
//   }) async {
//     try {
//       if (userId.trim().isEmpty || placeId.trim().isEmpty) {
//         throw Exception('User ID e Place ID são obrigatórios');
//       }

//       await _userRepository.removeFavorite(userId, placeId);
//     } catch (e) {
//       print('❌ Erro ao remover favorito: $e');
//       rethrow;
//     }
//   }
// }
