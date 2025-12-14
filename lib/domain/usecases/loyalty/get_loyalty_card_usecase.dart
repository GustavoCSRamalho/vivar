// // domain/usecases/loyalty/get_loyalty_card_usecase.dart

// import '../../entity/loyalt/loyalty_card_entity.dart';
// import '../../interface/loyalty/loyalty_repository_protocol.dart';

// class GetLoyaltyCardUseCase {
//   final LoyaltyRepositoryProtocol _repository;

//   GetLoyaltyCardUseCase(this._repository);

//   Future<LoyaltyCardEntity?> execute(String userId) async {
//     if (userId.trim().isEmpty) {
//       throw Exception('ID do usuário é obrigatório');
//     }

//     try {
//       return await _repository.getLoyaltyCard(userId);
//     } catch (e) {
//       print('❌ Erro ao buscar cartão fidelidade: $e');
//       rethrow;
//     }
//   }
// }
