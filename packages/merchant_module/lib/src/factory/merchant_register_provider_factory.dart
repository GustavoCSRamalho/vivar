// presentation/providers/merchant_register_provider_factory.dart

import 'package:merchant_module/src/domain/usecase/register_merchant_usecase.dart';
import 'package:merchant_module/src/domain/usecase/validate_merchant_data_usecase.dart';

import '../data/datasource/merchant_datasource.dart';
import '../data/datasource/merchant_remote_datasource_impl.dart';
import '../data/datasource/merchant_sync_datasource.dart';
import '../data/repositories/merchant_repository_impl.dart';
import '../presentation/providers/merchant_register_provider.dart';

class MerchantRegisterProviderFactory {
  static MerchantRegisterProvider create() {
    final datasource = MerchantLocalDatasourceImpl();
    final remoteDataSource = MerchantRemoteDatasourceImpl();
    final syncDataSource = MerchantSyncDatasource(
      localDatasource: datasource,
      remoteDatasource: remoteDataSource,
    );
    final repository = MerchantRepositoryImpl(syncDatasource: syncDataSource);

    final registerMerchantUseCase = RegisterMerchantUseCase(repository);
    final validateMerchantDataUseCase = ValidateMerchantDataUseCase();

    return MerchantRegisterProvider(
      registerMerchantUseCase: registerMerchantUseCase,
      validateMerchantDataUseCase: validateMerchantDataUseCase,
    );
  }
}
