// login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/constants/routes.dart';
import 'package:vivar/screens/home/data/models/user_model.dart';
import 'package:vivar/providers/user_provider.dart';
import 'package:vivar/widgets/buttons/custom_text_field.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/social_button.dart';
import '../../widgets/inputs/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60),

              // Logo
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 35),
                ),
              ),

              SizedBox(height: 32),

              // Título
              Text(
                'Bem-vindo!',
                style: AppTextStyles.h1,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              // Subtítulo
              Text(
                'Entre ou crie sua conta para começar',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // Botão Google
              SocialButton(
                icon: 'assets/icons/google.png',
                text: 'Continuar com Google',
                onPressed: () => _loginWithGoogle(),
                backgroundColor: Colors.white,
                textColor: AppColors.textPrimary,
              ),

              SizedBox(height: 12),

              // Botão Apple
              SocialButton(
                icon: 'assets/icons/apple.png',
                text: 'Continuar com Apple',
                onPressed: () => _loginWithApple(),
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),

              SizedBox(height: 24),

              // Divisor "ou"
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'ou',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),

              SizedBox(height: 24),

              // Campo Email
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                hintText: 'seu@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),

              SizedBox(height: 16),

              // Campo Senha
              CustomTextField(
                controller: _passwordController,
                label: 'Senha',
                hintText: '••••••••',
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),

              SizedBox(height: 8),

              // Esqueci a senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _forgotPassword(),
                  child: Text(
                    'Esqueci a senha',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Botão Entrar
              PrimaryButton(
                text: 'Entrar',
                onPressed: () => _login(),
                isLoading: _isLoading,
              ),

              SizedBox(height: 24),

              // Link Cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem conta? ',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      'Cadastre-se',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginWithGoogle() {
    // Implementar login com Google
  }

  void _loginWithApple() {
    // Implementar login com Apple
  }

  void _forgotPassword() {
    // Implementar recuperação de senha
  }

  void _login() async {
    setState(() => _isLoading = true);
    // Implementar lógica de login
    await Future.delayed(Duration(seconds: 2));
    final userProvider = context.read<UserProvider>();
    userProvider.saveUser(
      UserModel(
        id: 'user_123',
        email: 'gustavo.ramalho@example.com',
        name: 'Gustavo Ramalho',
        createdAt: DateTime(2024, 1, 10, 14, 30),
        updatedAt: DateTime(2025, 11, 9, 12, 00),
      ),
    );

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, AppRoutes.profile);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
