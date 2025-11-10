// screens/profile/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: Text('Configurações'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.horizontalPadding),
        children: [
          _buildSection(
            context,
            title: 'CONTA',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.lock_outline,
                title: 'Senha e segurança',
                subtitle: 'Alterar senha, 2FA',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.credit_card,
                title: 'Pagamentos',
                subtitle: 'Cartões e métodos',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'Localização',
                subtitle: 'Permissões e precisão',
                onTap: () {},
              ),
            ],
          ),

          SizedBox(height: 32),

          _buildSection(
            context,
            title: 'PREFERÊNCIAS',
            items: [
              _buildSwitchItem(
                context,
                icon: Icons.dark_mode_outlined,
                title: 'Tema escuro',
                value: false,
                onChanged: (value) {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: 'Idioma',
                subtitle: 'Português (BR)',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.straighten,
                title: 'Unidade de distância',
                subtitle: 'Quilômetros',
                onTap: () {},
              ),
            ],
          ),

          SizedBox(height: 32),

          _buildSection(
            context,
            title: 'SUPORTE',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.help_outline,
                title: 'Central de ajuda',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.chat_bubble_outline,
                title: 'Falar com suporte',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.star_outline,
                title: 'Avaliar o app',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.feedback_outlined,
                title: 'Enviar feedback',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.bug_report_outlined,
                title: 'Reportar problema',
                onTap: () {},
              ),
            ],
          ),

          SizedBox(height: 32),

          _buildSection(
            context,
            title: 'LEGAL',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                title: 'Termos de uso',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Política de privacidade',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.copyright,
                title: 'Licenças',
                onTap: () {},
              ),
            ],
          ),

          SizedBox(height: 32),

          _buildSection(
            context,
            title: 'SOBRE',
            items: [
              _buildMenuItem(
                context,
                icon: Icons.info_outline,
                title: 'Sobre o Vivar',
                subtitle: 'Versão 1.0.0',
                onTap: () {},
              ),
              _buildMenuItem(
                context,
                icon: Icons.store,
                title: 'Sou um comerciante',
                subtitle: 'Cadastre seu negócio',
                onTap: () => Navigator.pushNamed(context, '/merchant-register'),
              ),
            ],
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.success,
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isPremium = userProvider.isPremium;

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.primary, AppColors.accent]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isPremium ? 'PREMIUM' : 'GRATUITO',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            isPremium ? 'Plano Premium' : 'Plano Gratuito',
            style: AppTextStyles.subtitle.copyWith(color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            isPremium
                ? 'Você tem acesso completo'
                : 'Faça upgrade e economize mais',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          if (!isPremium) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/vivar-plus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Ver planos'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          'Sair',
          style: AppTextStyles.body.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sair'),
        content: Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserProvider>().logout();
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
