// screens/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/screens/auth/presentation/providers/login_provider.dart';
import 'package:vivar/screens/profile/presentation/providers/profile_provider.dart';
import 'package:vivar/screens/profile/presentation/providers/settings_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/constants/routes.dart';
import '../../../widgets/buttons/custom_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await context.read<LoginProvider>().currentUser;
    if (user != null) {
      await context.read<ProfileProvider>().loadProfile(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.profile;

          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (profile == null) {
            return _buildNotLoggedIn();
          }

          return CustomScrollView(
            slivers: [
              // Header com gradiente
              SliverAppBar(
                expandedHeight: 316,
                pinned: false,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // Botão configurações
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.settings, color: Colors.white),
                              onPressed: _openSettings,
                            ),
                          ),

                          SizedBox(height: 20),

                          // Avatar
                          GestureDetector(
                            onTap: _editProfile,
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: profile.avatarUrl != null
                                        ? NetworkImage(profile.avatarUrl!)
                                        : null,
                                    child: profile.avatarUrl == null
                                        ? Text(
                                            profile.name[0].toUpperCase(),
                                            style: AppTextStyles.h2.copyWith(
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          // Nome
                          Text(
                            profile.name,
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 4),

                          // Email
                          Text(
                            profile.email,
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),

                          SizedBox(height: 16),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                '0', //'${profile.placesVisited}',
                                'Lugares',
                              ),
                              _buildStatItem('${profile.points}', 'Pontos'),
                              _buildStatItem(
                                '${profile.badgesCount}',
                                'Badges',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Conteúdo
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Card Plano Atual
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: _buildPlanCard(profile),
                    ),

                    // Conquistas
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Conquistas', style: AppTextStyles.h3),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),

                    // Scroll horizontal de badges
                    SizedBox(
                      height: 172,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildBadgeCard(index);
                        },
                      ),
                    ),

                    SizedBox(height: 32),

                    // Menu de opções
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.edit,
                            title: 'Editar perfil',
                            onTap: _editProfile,
                          ),
                          // SizedBox(height: 8),
                          // _buildMenuItem(
                          //   icon: Icons.credit_card,
                          //   title: 'Cartão fidelidade',
                          //   onTap: _openLoyaltyCard,
                          // ),
                          // SizedBox(height: 8),
                          // _buildMenuItem(
                          //   icon: Icons.emoji_events,
                          //   title: 'Desafios',
                          //   onTap: _openChallenges,
                          // ),
                          SizedBox(height: 8),
                          _buildMenuItem(
                            icon: Icons.bookmark,
                            title: 'Lugares salvos',
                            onTap: _openFavorites,
                          ),
                          SizedBox(height: 8),
                          _buildMenuItem(
                            icon: Icons.workspace_premium,
                            title: 'Assinar Vizinho+',
                            onTap: _openVizinhoPlus,
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'PRO',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notificações',
                            onTap: _openNotifications,
                          ),
                          // SizedBox(height: 8),
                          // _buildMenuItem(
                          //   icon: Icons.help_outline,
                          //   title: 'Ajuda e suporte',
                          //   onTap: _openHelp,
                          // ),
                          // SizedBox(height: 8),
                          // _buildMenuItem(
                          //   icon: Icons.info_outline,
                          //   title: 'Sobre o app',
                          //   onTap: _openAbout,
                          // ),
                          SizedBox(height: 8),
                          _buildMenuItem(
                            icon: Icons.store,
                            title: 'Sou um comerciante',
                            onTap: _openMerchantRegister,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Botão Indicar amigos
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: _shareApp,
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.share, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'Indicar amigos',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Botão Sair
                    TextButton(
                      onPressed: _logout,
                      child: Text(
                        'Sair',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 100), // Espaço para bottom nav
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 80, color: AppColors.textSecondary),
            SizedBox(height: 24),
            Text(
              'Faça login para continuar',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Entre para acessar seu perfil e aproveitar todos os benefícios',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text('Fazer Login', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h3.copyWith(color: Colors.white)),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(user) {
    final isPremium = user.planType == 'premium';

    return GestureDetector(
      onTap: isPremium ? null : _openVizinhoPlus,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isPremium ? AppColors.accent : Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isPremium ? 'VIZINHO+' : 'GRATUITO',
                style: AppTextStyles.caption.copyWith(
                  color: isPremium ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              isPremium ? 'Plano Vizinho+' : 'Plano Gratuito',
              style: AppTextStyles.subtitle,
            ),
            SizedBox(height: 16),
            ...(isPremium
                    ? [
                        'Todos os descontos',
                        'Sem anúncios',
                        'Prioridade em eventos',
                        'Badges exclusivos',
                      ]
                    : [
                        'Descobrir lugares',
                        'Check-ins e pontos',
                        'Descontos ocasionais',
                      ])
                .map(
                  (benefit) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(benefit, style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                )
                .toList(),
            if (!isPremium) ...[
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Upgrade para Vizinho+ ✨',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Por R\$ 19,90/mês',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(int index) {
    final badges = [
      {'icon': '🌟', 'name': 'Explorador', 'desc': 'Visitou 10 lugares'},
      {'icon': '☕', 'name': 'Café Lover', 'desc': '5 cafeterias visitadas'},
      {'icon': '🎯', 'name': 'Primeira vez', 'desc': 'Primeiro check-in'},
      {'icon': '🔥', 'name': 'Sequência', 'desc': '7 dias seguidos'},
      {'icon': '⭐', 'name': 'Avaliador', 'desc': '10 reviews escritas'},
    ];

    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(badges[index]['icon'] as String, style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text(
            badges[index]['name'] as String,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            badges[index]['desc'] as String,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
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
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    Navigator.pushNamed(context, AppRoutes.editProfile);
  }

  void _openSettings() {
    Navigator.pushNamed(context, AppRoutes.settings);
  }

  void _openLoyaltyCard() {
    Navigator.pushNamed(context, AppRoutes.loyaltyCard);
  }

  void _openChallenges() {
    Navigator.pushNamed(context, AppRoutes.challenges);
  }

  void _openFavorites() {
    // TODO: Criar tela de favoritos
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Lugares salvos em breve')));
  }

  void _openVizinhoPlus() {
    Navigator.pushNamed(context, AppRoutes.vivarPlus);
  }

  void _openNotifications() {
    Navigator.pushNamed(context, AppRoutes.notifications);
  }

  void _openMerchantRegister() {
    Navigator.pushNamed(context, AppRoutes.merchantRegister);
  }

  void _openHelp() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Ajuda e suporte em breve')));
  }

  void _openAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Vizinho',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.location_on,
        size: 48,
        color: AppColors.primary,
      ),
      children: [
        Text('Descubra e explore os melhores lugares da sua vizinhança!'),
      ],
    );
  }

  void _shareApp() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Compartilhar app em breve')));
  }

  void _logout() {
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
              context.read<SettingsProvider>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (route) => false,
              );
            },
            child: Text('Sair', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _onNavBarTap(int index) {
    if (index == 4) return; // Já está no Profile

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.discover);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.swipe);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.map);
        break;
    }
  }
}
