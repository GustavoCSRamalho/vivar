// screens/loyalty_card/loyalty_card_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../packages/design_system_module/lib/src/constants/colors.dart';
import '../../../../packages/design_system_module/lib/src/constants/text_styles.dart';
import '../../../../packages/design_system_module/lib/src/constants/spacing.dart';
import '../../../../packages/authentication_module/lib/src/presentation/login/login_provider.dart';
import 'package:vivar/screens/loyalty_card/presentation/providers/loyalty_card_provider.dart';

class LoyaltyCardScreen extends StatefulWidget {
  @override
  _LoyaltyCardScreenState createState() => _LoyaltyCardScreenState();
}

class _LoyaltyCardScreenState extends State<LoyaltyCardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final loginProvider = context.read<LoginProvider>();
    final loyaltyProvider = context.read<LoyaltyCardProvider>();

    if (loginProvider.currentUser != null) {
      await loyaltyProvider.loadLoyaltyData(loginProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Meu Cartão'),
        actions: [
          IconButton(icon: Icon(Icons.qr_code), onPressed: _showQRCode),
        ],
      ),
      body: Consumer<LoyaltyCardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.loyaltyCard == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.loyaltyCard == null) {
            return Center(child: Text('Cartão não encontrado'));
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.horizontalPadding),
              children: [
                SizedBox(height: 24),
                _buildVirtualCard(provider.loyaltyCard!),
                SizedBox(height: 24),
                _buildStatsGrid(provider.loyaltyCard!),
                SizedBox(height: 32),
                _buildActiveBenefits(provider),
                SizedBox(height: 32),
                _buildRecentActivity(provider),
                SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVirtualCard(card) {
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
                    card.planType.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
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
                      card.userName,
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '#${card.cardNumber}',
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
                          '${card.points}',
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

  Widget _buildStatsGrid(card) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '🏪',
            '${card.businessesVisited}',
            'Lugares\nvisitados',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🎟️',
            '${card.activeCoupons}',
            'Cupons\nativos',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🏆',
            '${card.badgesCount}',
            'Badges\nconquistados',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🔥',
            '${card.streakDays}',
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

  Widget _buildActiveBenefits(provider) {
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
        if (provider.activeBenefits.isEmpty)
          Center(child: Text('Nenhum benefício ativo'))
        else
          SizedBox(
            height: 191,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.activeBenefits.length,
              itemBuilder: (context, index) {
                return _buildBenefitCard(provider.activeBenefits[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBenefitCard(benefit) {
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
              benefit.title,
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Text(benefit.merchantName, style: AppTextStyles.subtitle),
          SizedBox(height: 8),
          Text(
            benefit.description,
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
                  'Válido até ${benefit.validUntil.day}/${benefit.validUntil.month}/${benefit.validUntil.year}',
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

  Widget _buildRecentActivity(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Atividade recente', style: AppTextStyles.h3),
        SizedBox(height: 16),
        if (provider.recentActivities.isEmpty)
          Center(child: Text('Nenhuma atividade recente'))
        else
          ...provider.recentActivities
              .map((activity) => _buildActivityItem(activity))
              .toList(),
        SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () async {
              final loginProvider = context.read<LoginProvider>();
              if (loginProvider.currentUser != null) {
                await provider.loadMoreActivities(
                  loginProvider.currentUser!.id,
                );
              }
            },
            child: Text('Ver histórico completo'),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(activity) {
    final isPositive = activity.pointsChange > 0;

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
              color: _getActivityColor(activity.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity.type),
              color: _getActivityColor(activity.type),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  activity.subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _getTimeAgo(activity.timestamp),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${activity.pointsChange}',
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

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);

    if (difference.inDays > 7) {
      return 'Há ${(difference.inDays / 7).floor()} semana${difference.inDays > 14 ? 's' : ''}';
    } else if (difference.inDays > 0) {
      return 'Há ${difference.inDays} dia${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Há ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else {
      return 'Há ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    }
  }

  Future<void> _showQRCode() async {
    final loginProvider = context.read<LoginProvider>();
    final loyaltyProvider = context.read<LoyaltyCardProvider>();

    if (loginProvider.currentUser == null) return;

    final qrCode = await loyaltyProvider.generateQRCode(
      loginProvider.currentUser!.id,
    );

    if (!mounted || qrCode == null) return;

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
                child: Center(
                  child: Text('QR CODE\n$qrCode', textAlign: TextAlign.center),
                ),
              ),
              SizedBox(height: 16),
              Text(
                '#$qrCode',
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
