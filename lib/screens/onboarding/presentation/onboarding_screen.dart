// screens/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/constants/routes.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/core/constants/spacing.dart';
import 'package:vivar/screens/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:vivar/widgets/buttons/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.explore,
      title: 'Explore seu bairro',
      description:
          'Encontre cafés, bares, lojas e experiências incríveis a poucos passos de você',
    ),
    OnboardingData(
      icon: Icons.local_offer,
      title: 'Descontos exclusivos',
      description:
          'Ganhe benefícios em estabelecimentos locais e acumule pontos a cada visita',
    ),
    OnboardingData(
      icon: Icons.people,
      title: 'Faça parte da comunidade',
      description:
          'Compartilhe experiências e descubra recomendações dos seus vizinhos',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<OnboardingProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _skipOnboarding(provider),
                    child: Text(
                      'Pular',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      provider.setPage(index);
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return OnboardingPage(data: _pages[index]);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: provider.currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: provider.currentPage == index
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.horizontalPadding,
                  ),
                  child: PrimaryButton(
                    text: provider.isLastPage ? 'Começar' : 'Próximo',
                    onPressed: provider.isCompleting
                        ? () => ()
                        : () => _handleButtonPress(provider),
                    isLoading: provider.isCompleting,
                  ),
                ),
                SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleButtonPress(OnboardingProvider provider) async {
    if (provider.isLastPage) {
      await _completeOnboarding(provider);
    } else {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding(OnboardingProvider provider) async {
    try {
      await provider.completeOnboarding();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.locationPermission);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao completar onboarding'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _skipOnboarding(OnboardingProvider provider) async {
    try {
      await provider.completeOnboarding();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.locationPermission);
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.locationPermission);
    }
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.accent.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(data.icon, size: 100, color: AppColors.primary),
          ),
          SizedBox(height: AppSpacing.xxxl * 2),
          Text(
            data.title,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            data.description,
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
}
