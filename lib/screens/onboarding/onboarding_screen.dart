// onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:vivar/core/constants/routes.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../core/constants/spacing.dart';
import '../../widgets/buttons/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Botão pular
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _skipOnboarding(),
                child: Text(
                  'Pular',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Indicadores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32),

            // Botão
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.horizontalPadding,
              ),
              child: PrimaryButton(
                text: _currentPage == _pages.length - 1 ? 'Começar' : 'Próximo',
                onPressed: () {
                  if (_currentPage == _pages.length - 1) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.locationPermission,
                    );
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.locationPermission);
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

  const OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ilustração/Ícone
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

          // Título
          Text(
            data.title,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSpacing.lg),

          // Descrição
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
