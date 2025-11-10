// screens/premium/vivar_plus_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/constants/text_styles.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../providers/user_provider.dart';
import '../../widgets/buttons/primary_button.dart';

class VivarPlusScreen extends StatelessWidget {
  static final ValueNotifier<bool> _showBottomBar = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // controla a posição do scroll para detectar se está no fim
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 50) {
            _showBottomBar.value = true;
          } else {
            _showBottomBar.value = false;
          }
          return true;
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  expandedHeight: 340,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(background: _buildHeader()),
                  leading: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // Conteúdo
                SliverToBoxAdapter(
                  child: Container(
                    transform: Matrix4.translationValues(0, -24, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _buildBenefitsSection(),
                          SizedBox(height: 32),
                          _buildTestimonialsSection(),
                          SizedBox(height: 32),
                          _buildFAQSection(),
                          SizedBox(height: 32),
                          _buildGuaranteeSection(),
                          SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom bar que aparece só no final
            ValueListenableBuilder<bool>(
              valueListenable: _showBottomBar,
              builder: (context, visible, child) {
                return AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  left: 0,
                  right: 0,
                  bottom: visible ? 0 : -200,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: Duration(milliseconds: 250),
                    child: _buildBottomBar(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'PREMIUM',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Vivar+',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Descontos ilimitados no seu bairro',
                style: AppTextStyles.subtitle.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                'R\$ 19,90',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
              Text(
                '/mês',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = [
      {
        'icon': Icons.local_offer,
        'title': 'Descontos ilimitados',
        'description': '15-30% OFF em 200+ estabelecimentos parceiros',
      },
      {
        'icon': Icons.star,
        'title': 'Ofertas exclusivas',
        'description':
            'Acesso a promoções que não aparecem para usuários gratuitos',
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Pontos em dobro',
        'description': 'Acumule pontos 2x mais rápido em cada check-in',
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'Brindes mensais',
        'description': 'Todo mês um presente surpresa em lugares parceiros',
      },
      {
        'icon': Icons.workspace_premium,
        'title': 'Badges especiais',
        'description': 'Conquistas exclusivas e destaque no app',
      },
      {
        'icon': Icons.rocket_launch,
        'title': 'Lançamentos em primeira mão',
        'description': 'Seja o primeiro a saber de novos lugares',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'O que você ganha',
          style: AppTextStyles.h2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        ...benefits.map((benefit) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    benefit['icon'] as IconData,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefit['title'] as String,
                        style: AppTextStyles.subtitle,
                      ),
                      SizedBox(height: 4),
                      Text(
                        benefit['description'] as String,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTestimonialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'O que dizem nosso Vivar+',
          style: AppTextStyles.h3,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildTestimonialCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(int index) {
    final testimonials = [
      {
        'name': 'Ana Silva',
        'location': 'São Paulo, SP',
        'text':
            'Já economizei mais de R\$ 200 no primeiro mês. Melhor investimento!',
      },
      {
        'name': 'Carlos Mendes',
        'location': 'Rio de Janeiro, RJ',
        'text': 'Os descontos exclusivos valem muito a pena. Recomendo!',
      },
      {
        'name': 'Mariana Costa',
        'location': 'Belo Horizonte, MG',
        'text': 'Descobri lugares incríveis e ainda economizo. Perfeito!',
      },
    ];

    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (i) => Icon(Icons.star, color: AppColors.accent, size: 16),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: Text(
              testimonials[index]['text']!,
              style: AppTextStyles.body.copyWith(height: 1.5),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  testimonials[index]['name']![0],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonials[index]['name']!,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      testimonials[index]['location']!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'Posso cancelar quando quiser?',
        'answer':
            'Sim! Você pode cancelar sua assinatura a qualquer momento sem multas ou taxas adicionais.',
      },
      {
        'question': 'Os descontos valem em qualquer horário?',
        'answer':
            'Sim, os descontos Vivar+ são válidos durante todo o horário de funcionamento dos estabelecimentos.',
      },
      {
        'question': 'Quantos lugares parceiros existem?',
        'answer':
            'Temos mais de 200 estabelecimentos parceiros e estamos sempre adicionando novos lugares.',
      },
      {
        'question': 'Como funciona o período de teste?',
        'answer':
            'Você tem 7 dias grátis para experimentar todos os benefícios. Se não gostar, cancele sem custo.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dúvidas frequentes', style: AppTextStyles.h3),
        SizedBox(height: 20),
        ...faqs.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        question,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            answer,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuaranteeSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFECFDF5),
        border: Border.all(color: AppColors.success, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.shield, color: AppColors.success, size: 48),
          SizedBox(height: 16),
          Text(
            'Garantia de 7 dias',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Se não gostar, devolvemos 100% do seu dinheiro. Sem perguntas.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '7 dias grátis, depois R\$ 19,90/mês',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            PrimaryButton(
              text: 'Começar teste grátis',
              onPressed: () => _startTrial(context),
            ),
            SizedBox(height: 8),
            Text(
              'Cancele quando quiser',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _startTrial(BuildContext context) async {
    // TODO: Implementar lógica de assinatura
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Começar teste grátis'),
        content: Text(
          'Funcionalidade de pagamento será implementada em breve.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
