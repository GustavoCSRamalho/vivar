// domain/usecases/loyalty/generate_qr_code_usecase.dart

import '../../interface/loyalty/loyalty_repository_protocol.dart';

class GenerateQRCodeUseCase {
  final LoyaltyRepositoryProtocol _repository;

  GenerateQRCodeUseCase(this._repository);

  Future<String> execute(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID do usuário é obrigatório');
    }

    try {
      return await _repository.generateQRCode(userId);
    } catch (e) {
      print('❌ Erro ao gerar QR Code: $e');
      rethrow;
    }
  }
}
