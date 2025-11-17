// location_permission_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/spacing.dart';
import '../../../widgets/buttons/primary_button.dart';

class LocationPermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ilustração
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Icon(Icons.location_on, size: 100, color: Colors.white),
              ),

              SizedBox(height: 32),

              // Título
              Text(
                'Ative sua localização',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),

              // Descrição
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Para mostrar experiências e lugares próximos de você, precisamos da sua localização',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 40),

              // Benefícios
              _buildBenefit('Descubra lugares a poucos minutos de você'),
              SizedBox(height: 20),
              _buildBenefit('Receba ofertas exclusivas do seu bairro'),
              SizedBox(height: 20),
              _buildBenefit('Veja eventos acontecendo agora por perto'),

              SizedBox(height: 48),

              // Botão Permitir
              PrimaryButton(
                text: 'Permitir localização',
                onPressed: () => _requestLocationPermission(context),
              ),

              SizedBox(height: 12),

              // Botão Agora não
              TextButton(
                onPressed: () => _skipLocationPermission(context),
                child: Text(
                  'Agora não',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, color: Colors.white, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ],
    );
  }

  void _requestLocationPermission(BuildContext context) async {
    // Implementar solicitação de permissão de localização
    // Usar package: permission_handler ou geolocator
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _skipLocationPermission(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
