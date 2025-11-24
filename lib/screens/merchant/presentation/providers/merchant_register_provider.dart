// presentation/providers/merchant_register_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/business/business_entity.dart';
import 'package:vivar/domain/entity/merchant/merchant_entity.dart';
import 'package:vivar/domain/usecases/merchant/register_merchant_usecase.dart';
import 'package:vivar/domain/usecases/merchant/validate_merchant_data_usecase.dart';

class MerchantRegisterProvider with ChangeNotifier {
  final RegisterMerchantUseCase _registerMerchantUseCase;
  final ValidateMerchantDataUseCase _validateMerchantDataUseCase;

  MerchantRegisterProvider({
    required RegisterMerchantUseCase registerMerchantUseCase,
    required ValidateMerchantDataUseCase validateMerchantDataUseCase,
  }) : _registerMerchantUseCase = registerMerchantUseCase,
       _validateMerchantDataUseCase = validateMerchantDataUseCase;

  List<String> _selectedImages = [];
  List<String> _selectedAmenities = [];
  Map<String, String> _schedule = {};
  bool _isWhatsapp = true;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String? _error;

  List<String> get selectedImages => _selectedImages;
  List<String> get selectedAmenities => _selectedAmenities;
  Map<String, String> get schedule => _schedule;
  bool get isWhatsapp => _isWhatsapp;
  bool get acceptTerms => _acceptTerms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get canSubmit => _acceptTerms && _selectedImages.isNotEmpty;

  void initialize() {
    _initializeSchedule();
  }

  void _initializeSchedule() {
    final days = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];

    for (var day in days) {
      _schedule[day] = '08:00 - 18:00';
    }
    notifyListeners();
  }

  void addImage(String imagePath) {
    if (_selectedImages.length < 5) {
      _selectedImages.add(imagePath);
      notifyListeners();
    }
  }

  void removeImage(String imagePath) {
    _selectedImages.remove(imagePath);
    notifyListeners();
  }

  void toggleAmenity(String amenity) {
    if (_selectedAmenities.contains(amenity)) {
      _selectedAmenities.remove(amenity);
    } else {
      _selectedAmenities.add(amenity);
    }
    notifyListeners();
  }

  void updateSchedule(String day, String schedule) {
    _schedule[day] = schedule;
    notifyListeners();
  }

  void setWhatsapp(bool value) {
    _isWhatsapp = value;
    notifyListeners();
  }

  void setAcceptTerms(bool value) {
    _acceptTerms = value;
    notifyListeners();
  }

  Future<bool> registerMerchant({
    required String name,
    required String category,
    required String address,
    required String phone,
    required String email,
    required String description,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final validation = _validateMerchantDataUseCase.execute(
        name: name,
        category: category,
        address: address,
        phone: phone,
        email: email,
        images: _selectedImages,
      );

      if (!validation.isValid) {
        _error = validation.errors.first;
        _setLoading(false);
        return false;
      }

      final merchant = BusinessEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        category: category,
        address: address,
        phone: phone,
        email: email,
        description: description,
        images: _selectedImages,
        schedule: _schedule,
        amenities: _selectedAmenities,
        isWhatsapp: _isWhatsapp,
        createdAt: DateTime.now(),
        city: 'Sao sebastiao',
        state: 'Maresias',
        updatedAt: DateTime.now(),
        latitude: 0,
        longitude: 0,
      );

      await _registerMerchantUseCase.execute(merchant);

      debugPrint('✅ Estabelecimento cadastrado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao cadastrar: $e';
      debugPrint('❌ Erro ao cadastrar estabelecimento: $e');
      _setLoading(false);
      return false;
    }
  }

  void reset() {
    _selectedImages = [];
    _selectedAmenities = [];
    _acceptTerms = false;
    _isWhatsapp = true;
    _initializeSchedule();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
