// screens/loyalty_card/loyalty_card_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../providers/user_provider.dart';
import '../../providers/checkins_provider.dart';

class LoyaltyCardScreen extends StatefulWidget {
  @override
  _LoyaltyCardScreenState createState() => _LoyaltyCardScreenState();
}

class _LoyaltyCardScreenState extends State<LoyaltyCardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = context.read<UserProvider>().currentUser;
    if (user != null) {
      await context.read<CheckinsProvider>().loadUserCheckins(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Meu Cartão'),
        actions: [
          IconButton(icon: Icon(Icons.qr_code), onPressed: () => _showQRCode()),
        ],
      ),
      body: Consumer2<UserProvider, CheckinsProvider>(
        builder: (context, userProvider, checkinsProvider, child) {
          final user = userProvider.currentUser;

          if (user == null) {
            return Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.horizontalPadding),
              children: [
                SizedBox(height: 24),

                // Cartão Virtual
                _buildVirtualCard(user),

                SizedBox(height: 24),

                // Stats
                _buildStatsGrid(user),

                SizedBox(height: 32),

                // Benefícios Ativos
                _buildActiveBenefits(),

                SizedBox(height: 32),

                // Histórico
                _buildRecentActivity(),

                SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVirtualCard(user) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vivar',
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user.planType.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),

            // Código de barras estilizado
            Row(
              children: List.generate(
                8,
                (index) => Container(
                  width: 3,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '#${user.id.substring(0, 8)}',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.accent, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${user.points}',
                          style: AppTextStyles.subtitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'pontos',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '🏪',
            '${user.placesVisited}',
            'Lugares\nvisitados',
          ),
        ),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard('🎟️', '8', 'Cupons\nativos')),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🏆',
            '${user.badgesCount}',
            'Badges\nconquistados',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🔥',
            '${user.streakDays}',
            'Dias de\nsequência',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String emoji, String value, String label) {
    return Container(
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
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 32)),
          SizedBox(height: 8),
          Text(value, style: AppTextStyles.h2.copyWith(fontSize: 24)),
          SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBenefits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Seus benefícios', style: AppTextStyles.h3),
            TextButton(onPressed: () {}, child: Text('Ver todos')),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 191,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildBenefitCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitCard(int index) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 12),
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
        border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '15% OFF',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Text('Café Raiz', style: AppTextStyles.subtitle),
          SizedBox(height: 8),
          Text(
            'Válido em todo o cardápio',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFFFF4E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, color: AppColors.primary, size: 16),
                SizedBox(width: 4),
                Text(
                  'Válido até 31/12/2025',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Atividade recente', style: AppTextStyles.h3),
        SizedBox(height: 16),
        ...List.generate(5, (index) => _buildActivityItem(index)),
        SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text('Ver histórico completo'),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        'type': 'checkin',
        'title': 'Check-in',
        'subtitle': 'Café Raiz',
        'time': 'Há 2 horas',
        'points': '+50',
      },
      {
        'type': 'coupon',
        'title': 'Cupom resgatado',
        'subtitle': 'Bistrô Central',
        'time': 'Ontem',
        'points': '-200',
      },
      {
        'type': 'checkin',
        'title': 'Check-in',
        'subtitle': 'Padaria Aurora',
        'time': 'Há 3 dias',
        'points': '+50',
      },
      {
        'type': 'badge',
        'title': 'Badge conquistado',
        'subtitle': 'Café Explorer',
        'time': 'Há 5 dias',
        'points': '+500',
      },
      {
        'type': 'checkin',
        'title': 'Check-in',
        'subtitle': 'Bar do João',
        'time': 'Há 1 semana',
        'points': '+50',
      },
    ];

    final activity = activities[index];
    final isPositive = activity['points']!.startsWith('+');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getActivityColor(activity['type']!).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity['type']!),
              color: _getActivityColor(activity['type']!),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  activity['subtitle']!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  activity['time']!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['points']!,
            style: AppTextStyles.body.copyWith(
              color: isPositive ? AppColors.success : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'checkin':
        return Icons.location_on;
      case 'coupon':
        return Icons.local_offer;
      case 'badge':
        return Icons.emoji_events;
      default:
        return Icons.star;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'checkin':
        return AppColors.success;
      case 'coupon':
        return AppColors.primary;
      case 'badge':
        return AppColors.accent;
      default:
        return AppColors.secondary;
    }
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 60, color: AppColors.primary),
              SizedBox(height: 20),
              Text(
                'Mostre para o estabelecimento',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('QR CODE')),
              ),
              SizedBox(height: 16),
              Text(
                '#VIZ-45821',
                style: AppTextStyles.subtitle.copyWith(letterSpacing: 2),
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
