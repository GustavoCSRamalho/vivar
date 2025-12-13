// screens/settings/settings_screen.dart

import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: Text('Configurações'), centerTitle: true),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.settings == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return ListView(
            padding: EdgeInsets.all(AppSpacing.horizontalPadding),
            children: [
              _buildSection(
                context,
                title: 'CONTA',
                items: [
                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.lock_outline,
                  //   title: 'Senha e segurança',
                  //   subtitle: 'Alterar senha, 2FA',
                  //   onTap: () {},
                  // ),
                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.credit_card,
                  //   title: 'Pagamentos',
                  //   subtitle: 'Cartões e métodos',
                  //   onTap: () {},
                  // ),
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
                  // _buildSwitchItem(
                  //   context,
                  //   provider: provider,
                  //   icon: Icons.dark_mode_outlined,
                  //   title: 'Tema escuro',
                  //   value: provider.settings.darkMode,
                  //   onChanged: provider.toggleDarkMode,
                  // ),
                  _buildMenuItem(
                    context,
                    icon: Icons.language,
                    title: 'Idioma',
                    subtitle: _getLanguageName(provider.settings.language),
                    onTap: () => _showLanguageDialog(provider),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.straighten,
                    title: 'Unidade de distância',
                    subtitle: provider.settings.distanceUnit == 'km'
                        ? 'Quilômetros'
                        : 'Milhas',
                    onTap: () => _showDistanceUnitDialog(provider),
                  ),
                ],
              ),
              SizedBox(height: 32),
              _buildSection(
                context,
                title: 'NOTIFICAÇÕES',
                items: [
                  _buildSwitchItem(
                    context,
                    provider: provider,
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    value: provider.settings.notificationsEnabled,
                    onChanged: provider.toggleNotifications,
                  ),
                ],
              ),
              SizedBox(height: 32),
              _buildSection(
                context,
                title: 'SUPORTE',
                items: [
                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.help_outline,
                  //   title: 'Central de ajuda',
                  //   onTap: () {},
                  // ),
                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.chat_bubble_outline,
                  //   title: 'Falar com suporte',
                  //   onTap: () {},
                  // ),
                  _buildMenuItem(
                    context,
                    icon: Icons.star_outline,
                    title: 'Avaliar o app',
                    onTap: () {},
                  ),
                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.feedback_outlined,
                  //   title: 'Enviar feedback',
                  //   onTap: () {},
                  // ),
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
                title: 'ARMAZENAMENTO',
                items: [
                  _buildMenuItem(
                    context,
                    icon: Icons.cleaning_services_outlined,
                    title: 'Limpar cache',
                    subtitle: 'Liberar espaço',
                    onTap: () => _clearCache(provider),
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
                    subtitle: 'Versão ${provider.appVersion}',
                    onTap: () {},
                  ),
                  // _buildMenuItem(
                  //   context,
                  //   icon: Icons.store,
                  //   title: 'Sou um comerciante',
                  //   subtitle: 'Cadastre seu negócio',
                  //   onTap: () => Navigator.pushNamed(
                  //     context,
                  //     AppRoutes.merchantRegister,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 32),
              _buildLogoutButton(context, provider),
              SizedBox(height: 40),
            ],
          );
        },
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
    required SettingsProvider provider,
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
        onChanged: provider.isLoading ? null : onChanged,
        activeColor: AppColors.success,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, SettingsProvider provider) {
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
        onTap: provider.isLoading ? null : () => _showLogoutDialog(provider),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'pt_BR':
        return 'Português (BR)';
      case 'en_US':
        return 'English (US)';
      case 'es_ES':
        return 'Español';
      default:
        return 'Português (BR)';
    }
  }

  void _showLanguageDialog(SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selecionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(provider, 'pt_BR', 'Português (BR)'),
            _buildLanguageOption(provider, 'en_US', 'English (US)'),
            _buildLanguageOption(provider, 'es_ES', 'Español'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    SettingsProvider provider,
    String code,
    String name,
  ) {
    final isSelected = provider.settings.language == code;
    return ListTile(
      title: Text(name),
      trailing: isSelected ? Icon(Icons.check, color: AppColors.success) : null,
      onTap: () {
        provider.updateLanguage(code);
        Navigator.pop(context);
      },
    );
  }

  void _showDistanceUnitDialog(SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unidade de distância'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDistanceUnitOption(provider, 'km', 'Quilômetros'),
            _buildDistanceUnitOption(provider, 'mi', 'Milhas'),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceUnitOption(
    SettingsProvider provider,
    String unit,
    String name,
  ) {
    final isSelected = provider.settings.distanceUnit == unit;
    return ListTile(
      title: Text(name),
      trailing: isSelected ? Icon(Icons.check, color: AppColors.success) : null,
      onTap: () {
        provider.updateDistanceUnit(unit);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _clearCache(SettingsProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar cache'),
        content: Text(
          'Deseja limpar o cache do aplicativo? Isso irá liberar espaço no dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await provider.clearCache();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Cache limpo com sucesso!' : 'Erro ao limpar cache',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  void _showLogoutDialog(SettingsProvider provider) {
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
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.logout();

              if (!mounted) return;

              if (success) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteConstants.login,
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao fazer logout'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
