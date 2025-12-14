// screens/subscription/vivar_plus_screen.dart

import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/subscription_provider.dart';

class VivarPlusScreen extends StatefulWidget {
  @override
  _VivarPlusScreenState createState() => _VivarPlusScreenState();
}

class _VivarPlusScreenState extends State<VivarPlusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().initialize('current_user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.error != null && provider.plans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () => provider.initialize('current_user_id'),
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: 24),
                    _buildBillingToggle(provider),
                    SizedBox(height: 24),
                    _buildPlans(provider),
                    SizedBox(height: 24),
                    _buildFeatures(),
                    SizedBox(height: 24),
                    _buildTestimonials(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stars, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Vivar Plus',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Desbloqueie o melhor da experiência',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Escolha seu plano',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Cancele quando quiser, sem custos adicionais',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle(provider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              'Mensal',
              !provider.isYearly,
              () => provider.toggleBillingPeriod(),
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              'Anual',
              provider.isYearly,
              () => provider.toggleBillingPeriod(),
              badge: 'Economize 25%',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            if (badge != null && isSelected) ...[
              SizedBox(height: 4),
              Text(
                badge,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlans(provider) {
    return Column(
      children: provider.plans.map<Widget>((plan) {
        return _buildPlanCard(provider, plan);
      }).toList(),
    );
  }

  Widget _buildPlanCard(provider, plan) {
    final price = provider.isYearly ? plan.yearlyPrice : plan.monthlyPrice;
    final billingPeriod = provider.isYearly ? 'ano' : 'mês';
    final monthlyEquivalent = provider.isYearly
        ? plan.yearlyPrice / 12
        : plan.monthlyPrice;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: plan.isPopular
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.isPopular)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Text(
                plan.badge,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: AppTextStyles.h3),
                SizedBox(height: 8),
                Text(
                  plan.description,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('R\$', style: AppTextStyles.h3.copyWith(fontSize: 20)),
                    Text(
                      price.toStringAsFixed(2).replaceAll('.', ','),
                      style: AppTextStyles.h1.copyWith(fontSize: 36),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '/$billingPeriod',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (provider.isYearly) ...[
                  SizedBox(height: 4),
                  Text(
                    'R\$ ${monthlyEquivalent.toStringAsFixed(2).replaceAll('.', ',')}/mês',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 20),
                ...plan.features.map((feature) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(feature, style: AppTextStyles.body),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _subscribe(provider, plan.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: plan.isPopular
                          ? AppColors.primary
                          : AppColors.secondary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Assinar agora',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Por que escolher Vivar Plus?', style: AppTextStyles.subtitle),
          SizedBox(height: 16),
          _buildFeatureItem(
            Icons.savings,
            'Economize até 50%',
            'Descontos exclusivos em parceiros',
          ),
          _buildFeatureItem(
            Icons.star,
            'Acesso VIP',
            'Lugares e eventos exclusivos',
          ),
          _buildFeatureItem(
            Icons.verified,
            'Sem anúncios',
            'Experiência premium sem interrupções',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'O que dizem nossos membros Plus',
            style: AppTextStyles.subtitle,
          ),
          SizedBox(height: 16),
          _buildTestimonial(
            'Maria Silva',
            'Economia de verdade! Já economizei mais de R\$ 500 em apenas 2 meses.',
            5,
          ),
          SizedBox(height: 12),
          _buildTestimonial(
            'João Santos',
            'Vale muito a pena! Os descontos são ótimos e os eventos VIP são incríveis.',
            5,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial(String name, String comment, int rating) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, child: Icon(Icons.person, size: 20)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        rating,
                        (index) =>
                            Icon(Icons.star, size: 12, color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(comment, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Future<void> _subscribe(provider, String planId) async {
    try {
      await provider.subscribe('current_user_id', planId);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Assinatura realizada com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao assinar: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
