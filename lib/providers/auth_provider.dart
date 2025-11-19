// // providers/auth_provider.dart
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vivar/screens/home/data/models/user_model.dart';
// import '../core/repositories/user_repository.dart';

// class AuthProvider with ChangeNotifier {
//   final UserRepository _userRepository = UserRepository();

//   UserModel? _currentUser;
//   bool _isLoading = false;
//   bool _isAuthenticated = false;
//   String? _error;
//   bool get isPremium => _currentUser?.planType == 'premium';

//   // Getters
//   UserModel? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   bool get isAuthenticated => _isAuthenticated;
//   String? get error => _error;
//   String get userName => _currentUser?.name ?? 'Usuário';
//   String get userEmail => _currentUser?.email ?? '';

//   // Chaves para SharedPreferences
//   static const String _authKey = 'user_id';
//   static const String _emailKey = 'user_email';
//   static const String _tokenKey = 'auth_token';

//   /// Inicializar autenticação (verificar se há sessão salva)
//   Future<void> initialize() async {
//     debugPrint('🔐 Inicializando AuthProvider...');

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString(_authKey);

//       if (userId != null && userId.isNotEmpty) {
//         debugPrint('📱 Sessão encontrada para userId: $userId');
//         await loadUser(userId);
//       } else {
//         debugPrint('❌ Nenhuma sessão ativa encontrada');
//         _isAuthenticated = false;
//       }
//     } catch (e) {
//       debugPrint('❌ Erro ao inicializar auth: $e');
//       _isAuthenticated = false;
//     }

//     notifyListeners();
//   }

//   /// Carregar dados do usuário
//   Future<void> loadUser(String userId) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final user = await _userRepository.getById(userId);

//       if (user != null) {
//         _currentUser = user;
//         _isAuthenticated = true;
//         _error = null;
//         debugPrint('✅ Usuário carregado: ${user.name}');
//       } else {
//         _isAuthenticated = false;
//         _error = 'Usuário não encontrado';
//         debugPrint('❌ Usuário não encontrado: $userId');
//         await _clearSession();
//       }
//     } catch (e) {
//       _error = e.toString();
//       _isAuthenticated = false;
//       debugPrint('❌ Erro ao carregar usuário: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Fazer login com email e senha
//   Future<bool> login(String email, String password) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       debugPrint('🔑 Tentando login: $email');

//       // Validações
//       if (email.isEmpty || password.isEmpty) {
//         throw Exception('Email e senha são obrigatórios');
//       }

//       if (!email.contains('@')) {
//         throw Exception('Email inválido');
//       }

//       if (password.length < 6) {
//         throw Exception('Senha deve ter no mínimo 6 caracteres');
//       }

//       // TODO: Implementar autenticação real com backend/Firebase
//       await Future.delayed(Duration(seconds: 2)); // Simular chamada API

//       // MOCK: Buscar usuário existente
//       final allUsers = await _userRepository.getAll();
//       UserModel? user = allUsers.firstWhere(
//         (u) => u.email.toLowerCase() == email.toLowerCase(),
//         orElse: () => UserModel(
//           id: '',
//           name: '',
//           email: '',
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//       );

//       // Se não encontrou, criar usuário mock para desenvolvimento
//       if (user.id.isEmpty) {
//         user = UserModel(
//           id: 'user_${DateTime.now().millisecondsSinceEpoch}',
//           name: email.split('@')[0].replaceAll('.', ' ').toUpperCase(),
//           email: email,
//           phone: '',
//           location: 'São Paulo, SP',
//           bio: '',
//           planType: 'free',
//           points: 0,
//           placesVisited: 0,
//           favoriteCount: 0,
//           badgesCount: 0,
//           streakDays: 0,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         );

//         await _userRepository.insert(user);
//         debugPrint('✅ Novo usuário criado: ${user.name}');
//       }

//       // Salvar sessão
//       await _saveSession(user.id, user.email);

//       _currentUser = user;
//       _isAuthenticated = true;
//       _error = null;

//       debugPrint('✅ Login realizado com sucesso: ${user.name}');

//       _isLoading = false;
//       notifyListeners();

//       return true;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isAuthenticated = false;
//       _isLoading = false;
//       debugPrint('❌ Erro no login: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Fazer registro com email e senha
//   Future<bool> register({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       debugPrint('📝 Tentando registrar: $email');

//       // Validações
//       if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
//         throw Exception('Todos os campos são obrigatórios');
//       }

//       if (name.trim().length < 3) {
//         throw Exception('Nome deve ter no mínimo 3 caracteres');
//       }

//       if (!email.contains('@') || !email.contains('.')) {
//         throw Exception('Email inválido');
//       }

//       if (password.length < 6) {
//         throw Exception('Senha deve ter no mínimo 6 caracteres');
//       }

//       // Verificar se email já existe
//       final existingUsers = await _userRepository.getAll();
//       final emailExists = existingUsers.any(
//         (u) => u.email.toLowerCase() == email.toLowerCase(),
//       );

//       if (emailExists) {
//         throw Exception('Este email já está cadastrado');
//       }

//       // TODO: Implementar registro real com backend/Firebase
//       await Future.delayed(Duration(seconds: 2)); // Simular chamada API

//       // Criar novo usuário
//       final newUser = UserModel(
//         id: 'user_${DateTime.now().millisecondsSinceEpoch}',
//         name: name.trim(),
//         email: email.trim().toLowerCase(),
//         phone: '',
//         location: 'São Paulo, SP',
//         bio: '',
//         planType: 'free',
//         points: 0,
//         placesVisited: 0,
//         favoriteCount: 0,
//         badgesCount: 0,
//         streakDays: 0,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       // Salvar no banco local
//       await _userRepository.insert(newUser);

//       // Salvar sessão
//       await _saveSession(newUser.id, newUser.email);

//       _currentUser = newUser;
//       _isAuthenticated = true;
//       _error = null;

//       debugPrint('✅ Registro realizado com sucesso: ${newUser.name}');

//       _isLoading = false;
//       notifyListeners();

//       return true;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isAuthenticated = false;
//       _isLoading = false;
//       debugPrint('❌ Erro no registro: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Login com Google
//   Future<bool> loginWithGoogle() async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       debugPrint('🔍 Tentando login com Google...');

//       // TODO: Implementar Google Sign-In
//       // await GoogleSignIn().signIn();
//       await Future.delayed(Duration(seconds: 1));

//       throw Exception('Login com Google ainda não implementado');
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isLoading = false;
//       debugPrint('❌ Erro no login com Google: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Login com Facebook
//   Future<bool> loginWithFacebook() async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       debugPrint('📘 Tentando login com Facebook...');

//       // TODO: Implementar Facebook Login
//       await Future.delayed(Duration(seconds: 1));

//       throw Exception('Login com Facebook ainda não implementado');
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isLoading = false;
//       debugPrint('❌ Erro no login com Facebook: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Login com Apple
//   Future<bool> loginWithApple() async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       debugPrint('🍎 Tentando login com Apple...');

//       // TODO: Implementar Apple Sign-In
//       await Future.delayed(Duration(seconds: 1));

//       throw Exception('Login com Apple ainda não implementado');
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isLoading = false;
//       debugPrint('❌ Erro no login com Apple: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Fazer logout
//   Future<void> logout() async {
//     try {
//       debugPrint('🚪 Fazendo logout...');

//       // Limpar sessão
//       await _clearSession();

//       _currentUser = null;
//       _isAuthenticated = false;
//       _error = null;

//       debugPrint('✅ Logout realizado com sucesso');

//       notifyListeners();
//     } catch (e) {
//       debugPrint('❌ Erro ao fazer logout: $e');
//     }
//   }

//   /// Atualizar dados do usuário
//   Future<bool> updateUser(UserModel updatedUser) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       // Atualizar no banco
//       await _userRepository.update(updatedUser);

//       // Atualizar estado local
//       _currentUser = updatedUser;
//       _error = null;

//       debugPrint('✅ Usuário atualizado: ${updatedUser.name}');

//       _isLoading = false;
//       notifyListeners();

//       return true;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isLoading = false;
//       debugPrint('❌ Erro ao atualizar usuário: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Atualizar perfil (método helper)
//   Future<bool> updateProfile({
//     String? name,
//     String? phone,
//     String? location,
//     String? userName,
//     String? bio,
//   }) async {
//     if (_currentUser == null) return false;

//     final updatedUser = _currentUser!.copyWith(
//       name: name,
//       phone: phone,
//       username: userName,
//       location: location,
//       bio: bio,
//       updatedAt: DateTime.now(),
//     );

//     return await updateUser(updatedUser);
//   }

//   /// Deletar conta
//   Future<bool> deleteAccount() async {
//     try {
//       if (_currentUser == null) return false;

//       _isLoading = true;
//       notifyListeners();

//       debugPrint('🗑️ Deletando conta: ${_currentUser!.email}');

//       // Deletar do banco
//       await _userRepository.delete(_currentUser!.id);

//       // Fazer logout
//       await logout();

//       debugPrint('✅ Conta deletada com sucesso');

//       return true;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isLoading = false;
//       debugPrint('❌ Erro ao deletar conta: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Recuperar senha
//   Future<bool> resetPassword(String email) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       debugPrint('📧 Enviando email de recuperação para: $email');

//       // Validação
//       if (email.isEmpty || !email.contains('@')) {
//         throw Exception('Email inválido');
//       }

//       // Verificar se email existe
//       final existingUsers = await _userRepository.getAll();
//       final emailExists = existingUsers.any(
//         (u) => u.email.toLowerCase() == email.toLowerCase(),
//       );

//       if (!emailExists) {
//         throw Exception('Email não encontrado');
//       }

//       // TODO: Implementar recuperação de senha real
//       await Future.delayed(Duration(seconds: 2));

//       debugPrint('✅ Email de recuperação enviado');

//       _isLoading = false;
//       notifyListeners();

//       return true;
//     } catch (e) {
//       _error = e.toString().replaceAll('Exception: ', '');
//       _isLoading = false;
//       debugPrint('❌ Erro ao recuperar senha: $e');
//       notifyListeners();
//       return false;
//     }
//   }

//   /// Salvar sessão no SharedPreferences
//   Future<void> _saveSession(String userId, String email) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_authKey, userId);
//       await prefs.setString(_emailKey, email);
//       await prefs.setString(
//         _tokenKey,
//         'mock_token_${DateTime.now().millisecondsSinceEpoch}',
//       );
//       debugPrint('💾 Sessão salva: $userId');
//     } catch (e) {
//       debugPrint('❌ Erro ao salvar sessão: $e');
//     }
//   }

//   /// Limpar sessão
//   Future<void> _clearSession() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_authKey);
//       await prefs.remove(_emailKey);
//       await prefs.remove(_tokenKey);
//       debugPrint('🗑️ Sessão limpa');
//     } catch (e) {
//       debugPrint('❌ Erro ao limpar sessão: $e');
//     }
//   }

//   /// Limpar erro
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   /// Verificar se está autenticado
//   bool get hasUser => _currentUser != null && _isAuthenticated;

//   /// Obter ID do usuário
//   String get userId => _currentUser?.id ?? '';
// }
