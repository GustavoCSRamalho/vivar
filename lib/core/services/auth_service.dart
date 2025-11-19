// // core/services/auth_service.dart
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Singleton
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;
//   AuthService._internal();

//   // ==================== GETTERS ====================

//   /// Obtém o usuário atual do Firebase
//   User? get currentUser => _auth.currentUser;

//   /// Obtém o ID do usuário atual
//   String? get currentUserId => _auth.currentUser?.uid;

//   /// Verifica se o usuário está autenticado
//   bool get isAuthenticated => _auth.currentUser != null;

//   /// Stream de mudanças no estado de autenticação
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // ==================== EMAIL/PASSWORD AUTH ====================

//   /// Registra novo usuário com email e senha
//   Future<UserCredential?> registerWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       debugPrint('📝 Registrando usuário: $email');

//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );

//       debugPrint('✅ Usuário registrado com sucesso: ${credential.user?.uid}');
//       return credential;
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro no registro: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado no registro: $e');
//       throw Exception('Erro ao criar conta. Tente novamente.');
//     }
//   }

//   /// Faz login com email e senha
//   Future<UserCredential?> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       debugPrint('🔑 Fazendo login: $email');

//       final credential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password,
//       );

//       debugPrint('✅ Login realizado com sucesso: ${credential.user?.uid}');
//       return credential;
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro no login: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado no login: $e');
//       throw Exception('Erro ao fazer login. Tente novamente.');
//     }
//   }

//   // ==================== GOOGLE SIGN-IN ====================

//   /// Faz login com Google
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       debugPrint('🔍 Iniciando login com Google...');

//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         debugPrint('❌ Login com Google cancelado pelo usuário');
//         return null;
//       }

//       debugPrint('✅ Usuário Google selecionado: ${googleUser.email}');

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       debugPrint('🔑 Autenticando com Firebase...');

//       // Sign in to Firebase with the Google credential
//       final userCredential = await _auth.signInWithCredential(credential);

//       debugPrint('✅ Login com Google realizado: ${userCredential.user?.uid}');
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro Firebase no login com Google: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro no login com Google: $e');
//       throw Exception('Erro ao fazer login com Google. Tente novamente.');
//     }
//   }

//   /// Faz logout do Google
//   Future<void> signOutGoogle() async {
//     try {
//       await _googleSignIn.signOut();
//       debugPrint('✅ Logout do Google realizado');
//     } catch (e) {
//       debugPrint('❌ Erro ao fazer logout do Google: $e');
//     }
//   }

//   // ==================== FACEBOOK SIGN-IN ====================
//   // Nota: Requer configuração adicional do pacote flutter_facebook_auth

//   /// Faz login com Facebook
//   /// TODO: Implementar quando o pacote flutter_facebook_auth for adicionado
//   Future<UserCredential?> signInWithFacebook() async {
//     try {
//       debugPrint('📘 Login com Facebook ainda não implementado');
//       throw Exception('Login com Facebook em desenvolvimento');

//       // Exemplo de implementação futura:
//       /*
//       final LoginResult result = await FacebookAuth.instance.login();
      
//       if (result.status == LoginStatus.success) {
//         final OAuthCredential credential = 
//             FacebookAuthProvider.credential(result.accessToken!.token);
//         return await _auth.signInWithCredential(credential);
//       }
      
//       return null;
//       */
//     } catch (e) {
//       debugPrint('❌ Erro no login com Facebook: $e');
//       throw Exception('Login com Facebook não disponível.');
//     }
//   }

//   // ==================== APPLE SIGN-IN ====================
//   // Nota: Requer configuração adicional do pacote sign_in_with_apple

//   /// Faz login com Apple
//   /// TODO: Implementar quando o pacote sign_in_with_apple for adicionado
//   Future<UserCredential?> signInWithApple() async {
//     try {
//       debugPrint('🍎 Login com Apple ainda não implementado');
//       throw Exception('Login com Apple em desenvolvimento');

//       // Exemplo de implementação futura:
//       /*
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       final oauthCredential = OAuthProvider("apple.com").credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode,
//       );

//       return await _auth.signInWithCredential(oauthCredential);
//       */
//     } catch (e) {
//       debugPrint('❌ Erro no login com Apple: $e');
//       throw Exception('Login com Apple não disponível.');
//     }
//   }

//   // ==================== PASSWORD RESET ====================

//   /// Envia email de recuperação de senha
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       debugPrint('📧 Enviando email de recuperação para: $email');

//       await _auth.sendPasswordResetEmail(email: email.trim());

//       debugPrint('✅ Email de recuperação enviado');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao enviar email de recuperação: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado ao enviar email: $e');
//       throw Exception('Erro ao enviar email de recuperação.');
//     }
//   }

//   /// Confirma a recuperação de senha com código
//   Future<void> confirmPasswordReset({
//     required String code,
//     required String newPassword,
//   }) async {
//     try {
//       debugPrint('🔐 Confirmando nova senha...');

//       await _auth.confirmPasswordReset(code: code, newPassword: newPassword);

//       debugPrint('✅ Senha alterada com sucesso');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao confirmar nova senha: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado ao confirmar senha: $e');
//       throw Exception('Erro ao alterar senha.');
//     }
//   }

//   // ==================== EMAIL VERIFICATION ====================

//   /// Envia email de verificação
//   Future<void> sendEmailVerification() async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       if (user.emailVerified) {
//         debugPrint('✅ Email já verificado');
//         return;
//       }

//       debugPrint('📧 Enviando email de verificação...');

//       await user.sendEmailVerification();

//       debugPrint('✅ Email de verificação enviado');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao enviar email de verificação: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao enviar email de verificação.');
//     }
//   }

//   /// Recarrega o usuário atual para verificar mudanças
//   Future<void> reloadUser() async {
//     try {
//       await _auth.currentUser?.reload();
//       debugPrint('✅ Dados do usuário recarregados');
//     } catch (e) {
//       debugPrint('❌ Erro ao recarregar usuário: $e');
//     }
//   }

//   // ==================== PROFILE UPDATES ====================

//   /// Atualiza o nome de exibição do usuário
//   Future<void> updateDisplayName(String displayName) async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       debugPrint('✏️ Atualizando nome de exibição: $displayName');

//       await user.updateDisplayName(displayName);
//       await user.reload();

//       debugPrint('✅ Nome de exibição atualizado');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao atualizar nome: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao atualizar nome.');
//     }
//   }

//   /// Atualiza a foto de perfil do usuário
//   Future<void> updatePhotoURL(String photoURL) async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       debugPrint('📸 Atualizando foto de perfil...');

//       await user.updatePhotoURL(photoURL);
//       await user.reload();

//       debugPrint('✅ Foto de perfil atualizada');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao atualizar foto: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao atualizar foto.');
//     }
//   }

//   /// Atualiza o email do usuário
//   Future<void> updateEmail(String newEmail) async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       debugPrint('📧 Atualizando email: $newEmail');

//       await user.verifyBeforeUpdateEmail(newEmail);

//       debugPrint('✅ Email de verificação enviado para o novo endereço');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao atualizar email: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao atualizar email.');
//     }
//   }

//   /// Atualiza a senha do usuário
//   Future<void> updatePassword(String newPassword) async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       debugPrint('🔐 Atualizando senha...');

//       await user.updatePassword(newPassword);

//       debugPrint('✅ Senha atualizada com sucesso');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao atualizar senha: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao atualizar senha.');
//     }
//   }

//   // ==================== RE-AUTHENTICATION ====================

//   /// Re-autentica o usuário (necessário para operações sensíveis)
//   Future<void> reauthenticate(String password) async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null || user.email == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       debugPrint('🔄 Re-autenticando usuário...');

//       final credential = EmailAuthProvider.credential(
//         email: user.email!,
//         password: password,
//       );

//       await user.reauthenticateWithCredential(credential);

//       debugPrint('✅ Re-autenticação realizada com sucesso');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro na re-autenticação: ${e.code}');
//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao re-autenticar.');
//     }
//   }

//   // ==================== ACCOUNT DELETION ====================

//   /// Deleta a conta do usuário
//   Future<void> deleteAccount() async {
//     try {
//       final user = _auth.currentUser;

//       if (user == null) {
//         throw Exception('Nenhum usuário autenticado');
//       }

//       debugPrint('🗑️ Deletando conta: ${user.uid}');

//       await user.delete();

//       debugPrint('✅ Conta deletada com sucesso');
//     } on FirebaseAuthException catch (e) {
//       debugPrint('❌ Erro ao deletar conta: ${e.code}');

//       // Requer re-autenticação para operações sensíveis
//       if (e.code == 'requires-recent-login') {
//         throw Exception(
//           'Por favor, faça login novamente antes de deletar sua conta.',
//         );
//       }

//       throw _handleAuthException(e);
//     } catch (e) {
//       debugPrint('❌ Erro inesperado: $e');
//       throw Exception('Erro ao deletar conta.');
//     }
//   }

//   // ==================== SIGN OUT ====================

//   /// Faz logout do usuário
//   Future<void> signOut() async {
//     try {
//       debugPrint('🚪 Fazendo logout...');

//       // Logout do Google se estiver conectado
//       if (await _googleSignIn.isSignedIn()) {
//         await _googleSignIn.signOut();
//       }

//       // Logout do Firebase
//       await _auth.signOut();

//       debugPrint('✅ Logout realizado com sucesso');
//     } catch (e) {
//       debugPrint('❌ Erro ao fazer logout: $e');
//       throw Exception('Erro ao fazer logout.');
//     }
//   }

//   // ==================== ERROR HANDLING ====================

//   /// Converte erros do Firebase em mensagens amigáveis
//   Exception _handleAuthException(FirebaseAuthException e) {
//     String message;

//     switch (e.code) {
//       case 'user-not-found':
//         message = 'Email não cadastrado.';
//         break;
//       case 'wrong-password':
//         message = 'Senha incorreta.';
//         break;
//       case 'email-already-in-use':
//         message = 'Este email já está sendo usado.';
//         break;
//       case 'invalid-email':
//         message = 'Email inválido.';
//         break;
//       case 'weak-password':
//         message = 'Senha muito fraca. Use pelo menos 6 caracteres.';
//         break;
//       case 'user-disabled':
//         message = 'Esta conta foi desativada.';
//         break;
//       case 'too-many-requests':
//         message = 'Muitas tentativas. Tente novamente mais tarde.';
//         break;
//       case 'operation-not-allowed':
//         message = 'Operação não permitida.';
//         break;
//       case 'invalid-credential':
//         message = 'Credenciais inválidas.';
//         break;
//       case 'requires-recent-login':
//         message = 'Por favor, faça login novamente para continuar.';
//         break;
//       case 'network-request-failed':
//         message = 'Erro de conexão. Verifique sua internet.';
//         break;
//       default:
//         message = 'Erro: ${e.message ?? e.code}';
//     }

//     return Exception(message);
//   }

//   // ==================== UTILITIES ====================

//   /// Verifica se o email está verificado
//   bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

//   /// Obtém o email do usuário atual
//   String? get userEmail => _auth.currentUser?.email;

//   /// Obtém o nome de exibição do usuário atual
//   String? get displayName => _auth.currentUser?.displayName;

//   /// Obtém a URL da foto de perfil do usuário atual
//   String? get photoURL => _auth.currentUser?.photoURL;

//   /// Obtém informações do provedor de autenticação
//   List<String> get providerIds {
//     return _auth.currentUser?.providerData
//             .map((info) => info.providerId)
//             .toList() ??
//         [];
//   }

//   /// Verifica se o usuário usou um provedor específico
//   bool hasProvider(String providerId) {
//     return providerIds.contains(providerId);
//   }
// }
