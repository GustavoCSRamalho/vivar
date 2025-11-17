// presentation/providers/merchant_register_provider_factory.dart

import 'package:vivar/screens/merchant/data/repositories/merchant_repository_impl.dart';
import 'package:vivar/screens/merchant/domain/usecases/merchant/register_merchant_usecase.dart';
import 'package:vivar/screens/merchant/domain/usecases/merchant/validate_merchant_data_usecase.dart';
import 'package:vivar/screens/merchant/presentation/providers/merchant_register_provider.dart';

class MerchantRegisterProviderFactory {
  static MerchantRegisterProvider create() {
    final repository = MerchantRepositoryImpl();

    final registerMerchantUseCase = RegisterMerchantUseCase(repository);
    final validateMerchantDataUseCase = ValidateMerchantDataUseCase();

    return MerchantRegisterProvider(
      registerMerchantUseCase: registerMerchantUseCase,
      validateMerchantDataUseCase: validateMerchantDataUseCase,
    );
  }
}
