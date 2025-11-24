// presentation/providers/edit_profile_provider.dart

import 'package:flutter/foundation.dart';
import 'package:vivar/domain/entity/profile/profile_entity.dart';
import 'package:vivar/domain/entity/user/user_profile_update_entity.dart';

import '../../../../domain/usecases/profile/get_profile_usecase.dart';
import '../../../../domain/usecases/profile/remove_avatar_usecase.dart';
import '../../../../domain/usecases/profile/update_user_profile_usecase.dart';
import '../../../../domain/usecases/profile/upload_avatar_usecase.dart';

class EditProfileProvider with ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UploadAvatarUseCase _uploadAvatarUseCase;
  final RemoveAvatarUseCase _removeAvatarUseCase;

  EditProfileProvider({
    required GetProfileUseCase getProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required UploadAvatarUseCase uploadAvatarUseCase,
    required RemoveAvatarUseCase removeAvatarUseCase,
  }) : _getProfileUseCase = getProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _uploadAvatarUseCase = uploadAvatarUseCase,
       _removeAvatarUseCase = removeAvatarUseCase;

  ProfileEntity? _profile;
  List<String> _selectedInterests = [];
  Map<String, bool> _privacySettings = {
    'public_profile': true,
    'show_location': true,
    'show_checkins': false,
  };
  bool _isLoading = false;
  String? _error;

  ProfileEntity? get profile => _profile;
  List<String> get selectedInterests => _selectedInterests;
  Map<String, bool> get privacySettings => _privacySettings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _profile = await _getProfileUseCase.execute(userId);
      debugPrint('✅ Perfil carregado para edição');
    } catch (e) {
      _error = 'Erro ao carregar perfil';
      debugPrint('❌ Erro ao carregar perfil: $e');
    } finally {
      _setLoading(false);
    }
  }

  void toggleInterest(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      _selectedInterests.add(interest);
    }
    notifyListeners();
  }

  void updatePrivacySetting(String key, bool value) {
    _privacySettings[key] = value;
    notifyListeners();
  }

  Future<bool> updateProfile({
    required String userId,
    required String name,
    String? username,
    String? bio,
    String? phone,
    String? location,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final profileUpdate = UserProfileUpdateEntity(
        userId: userId,
        name: name,
        username: username,
        bio: bio,
        phone: phone,
        location: location,
        interests: _selectedInterests,
        privacySettings: _privacySettings,
      );

      await _updateUserProfileUseCase.execute(profileUpdate);

      _profile = await _getProfileUseCase.execute(userId);

      debugPrint('✅ Perfil atualizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _getErrorMessage(e);
      debugPrint('❌ Erro ao atualizar perfil: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> uploadAvatar(String userId, String imagePath) async {
    _setLoading(true);
    _error = null;

    try {
      final avatarUrl = await _uploadAvatarUseCase.execute(userId, imagePath);

      if (_profile != null) {
        _profile = ProfileEntity(
          id: _profile!.id,
          email: _profile!.email,
          name: _profile!.name,
          username: _profile!.username,
          avatarUrl: avatarUrl,
          bio: _profile!.bio,
          phone: _profile!.phone,
          location: _profile!.location,
          planType: _profile!.planType,
          points: _profile!.points,
          // placesVisited: _profile!.placesVisited,
          badgesCount: _profile!.badgesCount,
          streakDays: _profile!.streakDays,
          favoriteCount: _profile!.favoriteCount,
          createdAt: _profile!.createdAt,
          updatedAt: DateTime.now(),
        );
      }

      debugPrint('✅ Avatar atualizado');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao fazer upload do avatar';
      debugPrint('❌ Erro no upload: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> removeAvatar(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      await _removeAvatarUseCase.execute(userId);

      if (_profile != null) {
        _profile = ProfileEntity(
          id: _profile!.id,
          email: _profile!.email,
          name: _profile!.name,
          username: _profile!.username,
          avatarUrl: null,
          bio: _profile!.bio,
          phone: _profile!.phone,
          location: _profile!.location,
          planType: _profile!.planType,
          points: _profile!.points,
          // placesVisited: _profile!.placesVisited,
          badgesCount: _profile!.badgesCount,
          streakDays: _profile!.streakDays,
          favoriteCount: _profile!.favoriteCount,
          createdAt: _profile!.createdAt,
          updatedAt: DateTime.now(),
        );
      }

      debugPrint('✅ Avatar removido');
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Erro ao remover avatar';
      debugPrint('❌ Erro ao remover avatar: $e');
      _setLoading(false);
      return false;
    }
  }

  String _getErrorMessage(dynamic error) {
    final message = error.toString();
    if (message.contains('Nome é obrigatório')) return 'Nome é obrigatório';
    if (message.contains('Nome deve ter no mínimo'))
      return 'Nome deve ter no mínimo 3 caracteres';
    if (message.contains('Username inválido'))
      return 'Username inválido. Use apenas letras, números e _';
    if (message.contains('Telefone inválido')) return 'Telefone inválido';
    return 'Erro ao atualizar perfil. Tente novamente.';
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
