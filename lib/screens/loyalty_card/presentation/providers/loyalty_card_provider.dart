// presentation/providers/loyalty_card_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/activity_entity.dart';
import 'package:vivar/domain/entity/benefit_entity.dart';
import 'package:vivar/domain/entity/loyalty_card_entity.dart';
import 'package:vivar/domain/usecases/loyalty/generate_qr_code_usecase.dart';
import 'package:vivar/domain/usecases/loyalty/get_active_benefits_usecase.dart';
import 'package:vivar/domain/usecases/loyalty/get_loyalty_card_usecase.dart';
import 'package:vivar/domain/usecases/loyalty/get_recent_activities_usecase.dart';
import 'package:vivar/domain/usecases/loyalty/redeem_benefit_usecase.dart';

class LoyaltyCardProvider with ChangeNotifier {
  final GetLoyaltyCardUseCase _getLoyaltyCardUseCase;
  final GetActiveBenefitsUseCase _getActiveBenefitsUseCase;
  final GetRecentActivitiesUseCase _getRecentActivitiesUseCase;
  final RedeemBenefitUseCase _redeemBenefitUseCase;
  final GenerateQRCodeUseCase _generateQRCodeUseCase;

  LoyaltyCardProvider({
    required GetLoyaltyCardUseCase getLoyaltyCardUseCase,
    required GetActiveBenefitsUseCase getActiveBenefitsUseCase,
    required GetRecentActivitiesUseCase getRecentActivitiesUseCase,
    required RedeemBenefitUseCase redeemBenefitUseCase,
    required GenerateQRCodeUseCase generateQRCodeUseCase,
  }) : _getLoyaltyCardUseCase = getLoyaltyCardUseCase,
       _getActiveBenefitsUseCase = getActiveBenefitsUseCase,
       _getRecentActivitiesUseCase = getRecentActivitiesUseCase,
       _redeemBenefitUseCase = redeemBenefitUseCase,
       _generateQRCodeUseCase = generateQRCodeUseCase;

  LoyaltyCardEntity? _loyaltyCard;
  List<BenefitEntity> _activeBenefits = [];
  List<ActivityEntity> _recentActivities = [];
  String? _qrCode;
  bool _isLoading = false;
  String? _error;

  LoyaltyCardEntity? get loyaltyCard => _loyaltyCard;
  List<BenefitEntity> get activeBenefits => _activeBenefits;
  List<ActivityEntity> get recentActivities => _recentActivities;
  String? get qrCode => _qrCode;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLoyaltyData(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _loyaltyCard = await _getLoyaltyCardUseCase.execute(userId);
      _activeBenefits = await _getActiveBenefitsUseCase.execute(userId);
      _recentActivities = await _getRecentActivitiesUseCase.execute(
        userId,
        limit: 5,
      );

      debugPrint('✅ Dados do cartão fidelidade carregados');
    } catch (e) {
      _error = 'Erro ao carregar dados do cartão';
      debugPrint('❌ Erro ao carregar cartão: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMoreActivities(String userId) async {
    try {
      final moreActivities = await _getRecentActivitiesUseCase.execute(
        userId,
        limit: _recentActivities.length + 10,
      );
      _recentActivities = moreActivities;
      notifyListeners();
      debugPrint('✅ Mais atividades carregadas');
    } catch (e) {
      debugPrint('❌ Erro ao carregar mais atividades: $e');
    }
  }

  Future<bool> redeemBenefit(String userId, String benefitId) async {
    _setLoading(true);
    _error = null;

    try {
      await _redeemBenefitUseCase.execute(userId, benefitId);

      // Recarregar dados
      await loadLoyaltyData(userId);

      debugPrint('✅ Benefício resgatado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao resgatar benefício';
      debugPrint('❌ Erro ao resgatar: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<String?> generateQRCode(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _qrCode = await _generateQRCodeUseCase.execute(userId);
      debugPrint('✅ QR Code gerado: $_qrCode');
      _setLoading(false);
      return _qrCode;
    } catch (e) {
      _error = 'Erro ao gerar QR Code';
      debugPrint('❌ Erro ao gerar QR Code: $e');
      _setLoading(false);
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
