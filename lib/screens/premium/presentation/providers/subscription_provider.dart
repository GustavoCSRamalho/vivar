// presentation/providers/subscription_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/subscription_plan_entity.dart';
import 'package:vivar/domain/entity/user_subscription_entity.dart';
import 'package:vivar/domain/usecases/subscription/cancel_subscription_usecase.dart';
import 'package:vivar/domain/usecases/subscription/get_available_plans_usecase.dart';
import 'package:vivar/domain/usecases/subscription/get_user_subscription_usecase.dart';
import 'package:vivar/domain/usecases/subscription/subscribe_to_plan_usecase.dart';

class SubscriptionProvider with ChangeNotifier {
  final GetAvailablePlansUseCase _getAvailablePlansUseCase;
  final GetUserSubscriptionUseCase _getUserSubscriptionUseCase;
  final SubscribeToPlanUseCase _subscribeToPlanUseCase;
  final CancelSubscriptionUseCase _cancelSubscriptionUseCase;

  SubscriptionProvider({
    required GetAvailablePlansUseCase getAvailablePlansUseCase,
    required GetUserSubscriptionUseCase getUserSubscriptionUseCase,
    required SubscribeToPlanUseCase subscribeToPlanUseCase,
    required CancelSubscriptionUseCase cancelSubscriptionUseCase,
  }) : _getAvailablePlansUseCase = getAvailablePlansUseCase,
       _getUserSubscriptionUseCase = getUserSubscriptionUseCase,
       _subscribeToPlanUseCase = subscribeToPlanUseCase,
       _cancelSubscriptionUseCase = cancelSubscriptionUseCase;

  List<SubscriptionPlanEntity> _plans = [];
  UserSubscriptionEntity? _currentSubscription;
  bool _isYearly = true;
  bool _isLoading = false;
  String? _error;

  List<SubscriptionPlanEntity> get plans => _plans;
  UserSubscriptionEntity? get currentSubscription => _currentSubscription;
  bool get isYearly => _isYearly;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveSubscription => _currentSubscription?.isActive ?? false;

  Future<void> initialize(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _plans = await _getAvailablePlansUseCase.execute();
      _currentSubscription = await _getUserSubscriptionUseCase.execute(userId);
      debugPrint('✅ Planos carregados: ${_plans.length}');
    } catch (e) {
      _error = 'Erro ao carregar planos: $e';
      debugPrint('❌ Erro ao carregar planos: $e');
    } finally {
      _setLoading(false);
    }
  }

  void toggleBillingPeriod() {
    _isYearly = !_isYearly;
    notifyListeners();
  }

  Future<void> subscribe(String userId, String planId) async {
    _setLoading(true);
    _error = null;

    try {
      await _subscribeToPlanUseCase.execute(userId, planId, _isYearly);
      _currentSubscription = await _getUserSubscriptionUseCase.execute(userId);
      debugPrint('✅ Assinatura realizada com sucesso');
    } catch (e) {
      _error = 'Erro ao assinar: $e';
      debugPrint('❌ Erro ao assinar: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelSubscription(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      await _cancelSubscriptionUseCase.execute(userId);
      _currentSubscription = null;
      debugPrint('✅ Assinatura cancelada');
    } catch (e) {
      _error = 'Erro ao cancelar: $e';
      debugPrint('❌ Erro ao cancelar: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
