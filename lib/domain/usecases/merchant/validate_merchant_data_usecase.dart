// domain/usecases/merchant/validate_merchant_data_usecase.dart

class ValidateMerchantDataUseCase {
  ValidationResult execute({
    required String name,
    required String category,
    required String address,
    required String phone,
    required String email,
    required List<String> images,
  }) {
    final errors = <String>[];

    if (name.trim().isEmpty) {
      errors.add('Nome do estabelecimento é obrigatório');
    }

    if (category.trim().isEmpty) {
      errors.add('Categoria é obrigatória');
    }

    if (address.trim().isEmpty) {
      errors.add('Endereço é obrigatório');
    }

    if (phone.trim().isEmpty) {
      errors.add('Telefone é obrigatório');
    } else if (phone.length < 10) {
      errors.add('Telefone inválido');
    }

    if (email.trim().isEmpty) {
      errors.add('Email é obrigatório');
    } else if (!email.contains('@') || !email.contains('.')) {
      errors.add('Email inválido');
    }

    if (images.isEmpty) {
      errors.add('Adicione pelo menos uma foto');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, required this.errors});
}
