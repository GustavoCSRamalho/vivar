// // domain/usecases/loyalty/get_active_benefits_usecase.dart

// import '../../entity/benefit/benefit_entity.dart';
// import '../../interface/loyalty/loyalty_repository_protocol.dart';

// class GetActiveBenefitsUseCase {
//   final LoyaltyRepositoryProtocol _repository;

//   GetActiveBenefitsUseCase(this._repository);

//   Future<List<BenefitEntity>> execute(String userId) async {
//     if (userId.trim().isEmpty) {
//       throw Exception('ID do usuário é obrigatório');
//     }

//     try {
//       return await _repository.getActiveBenefits(userId);
//     } catch (e) {
//       print('❌ Erro ao buscar benefícios: $e');
//       return [];
//     }
//   }
// }
