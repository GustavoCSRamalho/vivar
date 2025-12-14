// // presentation/providers/loyalty_card_provider_factory.dart

// import 'package:vivar/screens/loyalty_card/data/datasource/loyalty_datasource.dart';
// import 'package:vivar/screens/loyalty_card/data/repositories/loyalty_repository_impl.dart';
// import 'package:vivar/domain/usecases/loyalty/generate_qr_code_usecase.dart';
// import 'package:vivar/domain/usecases/loyalty/get_active_benefits_usecase.dart';
// import 'package:vivar/domain/usecases/loyalty/get_loyalty_card_usecase.dart';
// import 'package:vivar/domain/usecases/loyalty/get_recent_activities_usecase.dart';
// import 'package:vivar/domain/usecases/loyalty/redeem_benefit_usecase.dart';
// import 'package:vivar/screens/loyalty_card/presentation/providers/loyalty_card_provider.dart';

// class LoyaltyCardProviderFactory {
//   static LoyaltyCardProvider create() {
//     final datasource = LoyaltyDatasourceImpl();
//     final repository = LoyaltyRepositoryImpl(datasource: datasource);

//     final getLoyaltyCardUseCase = GetLoyaltyCardUseCase(repository);
//     final getActiveBenefitsUseCase = GetActiveBenefitsUseCase(repository);
//     final getRecentActivitiesUseCase = GetRecentActivitiesUseCase(repository);
//     final redeemBenefitUseCase = RedeemBenefitUseCase(repository);
//     final generateQRCodeUseCase = GenerateQRCodeUseCase(repository);

//     return LoyaltyCardProvider(
//       getLoyaltyCardUseCase: getLoyaltyCardUseCase,
//       getActiveBenefitsUseCase: getActiveBenefitsUseCase,
//       getRecentActivitiesUseCase: getRecentActivitiesUseCase,
//       redeemBenefitUseCase: redeemBenefitUseCase,
//       generateQRCodeUseCase: generateQRCodeUseCase,
//     );
//   }
// }
