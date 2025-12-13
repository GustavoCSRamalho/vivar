// screens/auth/login_screen.dart

import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Bem-vindo!',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Entre ou crie sua conta para começar',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                SocialButton(
                  icon: 'assets/icons/google.png',
                  text: 'Continuar com Google',
                  onPressed: _loginWithGoogle,
                  backgroundColor: Colors.white,
                  textColor: AppColors.textPrimary,
                ),
                SizedBox(height: 12),
                SocialButton(
                  icon: 'assets/icons/apple.png',
                  text: 'Continuar com Apple',
                  onPressed: _loginWithApple,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                ),
                SizedBox(height: 24),
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
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'seu@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email é obrigatório';
                    }
                    if (!value.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Consumer<LoginProvider>(
                  builder: (context, provider, child) {
                    return CustomTextField(
                      controller: _passwordController,
                      label: 'Senha',
                      hintText: '••••••••',
                      obscureText: provider.obscurePassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          provider.obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: provider.togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Senha é obrigatória';
                        }
                        if (value.length < 6) {
                          return 'Senha deve ter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: Text(
                      'Esqueci a senha',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Consumer<LoginProvider>(
                  builder: (context, provider, child) {
                    if (provider.error != null) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    provider.error!,
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
                Consumer<LoginProvider>(
                  builder: (context, provider, child) {
                    return PrimaryButton(
                      text: 'Entrar',
                      onPressed: provider.isLoading ? () => {} : _login,
                      isLoading: provider.isLoading,
                    );
                  },
                ),
                SizedBox(height: 24),
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
      ),
    );
  }

  Future<void> _loginWithGoogle() async {
    final provider = context.read<LoginProvider>();
    final success = await provider.loginWithGoogle();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, RouteConstants.profile);
    }
  }

  Future<void> _loginWithApple() async {
    final provider = context.read<LoginProvider>();
    final success = await provider.loginWithApple();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, RouteConstants.profile);
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<LoginProvider>();
    final success = await provider.loginWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, RouteConstants.profile);
    }
  }

  void _forgotPassword() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Recuperar senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Digite seu email para receber as instruções de recuperação'),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'seu@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final email = emailController.text;
              if (email.isEmpty) {
                return;
              }

              final provider = context.read<LoginProvider>();
              final success = await provider.sendPasswordReset(email);

              if (!mounted) return;
              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Email de recuperação enviado!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.error ?? 'Erro ao enviar email'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
