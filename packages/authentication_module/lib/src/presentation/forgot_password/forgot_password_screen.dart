// screens/auth/forgot_password_screen.dart

import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
        child: Consumer<ForgotPasswordProvider>(
          builder: (context, provider, child) {
            if (provider.currentStep == ForgotPasswordStep.emailSent) {
              return _buildEmailSentStep(provider);
            }
            return _buildEnterEmailStep(provider);
          },
        ),
      ),
    );
  }

  Widget _buildEnterEmailStep(ForgotPasswordProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.horizontalPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Esqueceu a senha?',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Não se preocupe! Digite seu email e enviaremos instruções para recuperar sua senha.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
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
            SizedBox(height: 24),
            if (provider.error != null) ...[
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 20),
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
            PrimaryButton(
              text: 'Enviar instruções',
              onPressed: provider.isLoading ? () => {} : _sendPasswordReset,
              isLoading: provider.isLoading,
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Voltar para o login',
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSentStep(ForgotPasswordProvider provider) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read,
              size: 60,
              color: AppColors.success,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Email enviado!',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Enviamos instruções de recuperação de senha para:',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            provider.sentEmail ?? '',
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Dicas importantes:',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildTip('Verifique sua caixa de entrada e spam'),
                _buildTip('O email pode levar alguns minutos'),
                _buildTip('O link expira em 24 horas'),
              ],
            ),
          ),
          SizedBox(height: 32),
          PrimaryButton(
            text: 'Voltar para o login',
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Não recebeu o email? ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (provider.isLoading)
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              else
                GestureDetector(
                  onTap: _resendEmail,
                  child: Text(
                    'Reenviar',
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
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(top: 6, right: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<ForgotPasswordProvider>();
    await provider.sendPasswordReset(_emailController.text);
  }

  Future<void> _resendEmail() async {
    final provider = context.read<ForgotPasswordProvider>();
    final success = await provider.resendEmail();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email reenviado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao reenviar email. Tente novamente.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
