// screens/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/constants/routes.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/screens/splash/presentation/providers/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final provider = context.read<SplashProvider>();
    await provider.initialize();

    await Future.delayed(Duration(seconds: 2));

    if (!mounted) return;

    switch (provider.state) {
      case SplashState.authenticated:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case SplashState.unauthenticated:
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        break;
      case SplashState.error:
        _showErrorDialog();
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Erro'),
        content: Text(
          context.read<SplashProvider>().error ?? 'Erro ao inicializar o app',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeApp();
            },
            child: Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.accent],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 70,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Vivar',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Descubra seu bairro',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 40),
                Consumer<SplashProvider>(
                  builder: (context, provider, child) {
                    if (provider.state == SplashState.error) {
                      return Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.white,
                      );
                    }
                    return SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
