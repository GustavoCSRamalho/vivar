// screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/constants/routes.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/core/constants/spacing.dart';
import 'package:vivar/screens/auth/presentation/providers/register_provider.dart';
import 'package:vivar/widgets/buttons/custom_text_field.dart';
import 'package:vivar/widgets/buttons/primary_button.dart';
import 'package:vivar/widgets/buttons/social_button.dart';
import 'package:vivar/widgets/inputs/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Text(
                  'Criar conta',
                  style: AppTextStyles.h1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Preencha seus dados para começar',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                SocialButton(
                  icon: 'assets/icons/google.png',
                  text: 'Cadastrar com Google',
                  onPressed: _registerWithGoogle,
                  backgroundColor: Colors.white,
                  textColor: AppColors.textPrimary,
                ),
                SizedBox(height: 12),
                SocialButton(
                  icon: 'assets/icons/apple.png',
                  text: 'Cadastrar com Apple',
                  onPressed: _registerWithApple,
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
                  controller: _nameController,
                  label: 'Nome completo',
                  hintText: 'João Silva',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    if (value.length < 3) {
                      return 'Nome deve ter no mínimo 3 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
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
                CustomTextField(
                  controller: _phoneController,
                  label: 'Telefone (opcional)',
                  hintText: '(00) 00000-0000',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),
                SizedBox(height: 16),
                Consumer<RegisterProvider>(
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
                SizedBox(height: 16),
                Consumer<RegisterProvider>(
                  builder: (context, provider, child) {
                    return CustomTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar senha',
                      hintText: '••••••••',
                      obscureText: provider.obscureConfirmPassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          provider.obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: provider.toggleConfirmPasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirme sua senha';
                        }
                        if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                Consumer<RegisterProvider>(
                  builder: (context, provider, child) {
                    return CheckboxListTile(
                      title: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: 'Li e aceito os '),
                            TextSpan(
                              text: 'Termos de Uso',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: ' e '),
                            TextSpan(
                              text: 'Política de Privacidade',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: provider.acceptTerms,
                      onChanged: (value) =>
                          provider.setAcceptTerms(value ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                    );
                  },
                ),
                SizedBox(height: 24),
                Consumer<RegisterProvider>(
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
                Consumer<RegisterProvider>(
                  builder: (context, provider, child) {
                    return PrimaryButton(
                      text: 'Criar conta',
                      onPressed: provider.canRegister && !provider.isLoading
                          ? _register
                          : () => {},
                      isLoading: provider.isLoading,
                    );
                  },
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem conta? ',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Entrar',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerWithGoogle() async {
    final provider = context.read<RegisterProvider>();
    final success = await provider.registerWithGoogle();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _registerWithApple() async {
    final provider = context.read<RegisterProvider>();
    final success = await provider.registerWithApple();

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<RegisterProvider>();
    final success = await provider.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      phone: _phoneController.text.isEmpty ? null : _phoneController.text,
    );

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 32),
              SizedBox(width: 12),
              Text('Sucesso!'),
            ],
          ),
          content: Text(
            'Sua conta foi criada com sucesso! Bem-vindo ao Vivar.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              child: Text('Começar'),
            ),
          ],
        ),
      );
    }
  }
}
