// check_in_modal.dart
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';
import '../../../core/constants/spacing.dart';
import '../../../widgets/buttons/primary_button.dart';

class CheckInModal extends StatefulWidget {
  @override
  _CheckInModalState createState() => _CheckInModalState();
}

class _CheckInModalState extends State<CheckInModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: _showSuccess ? _buildSuccessView() : _buildCheckInView(),
        ),
      ),
    );
  }

  Widget _buildCheckInView() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão fechar
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Ícone
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_on, size: 40, color: AppColors.primary),
          ),

          SizedBox(height: 24),

          // Título
          Text('Fazer Check-in', style: AppTextStyles.h2),

          SizedBox(height: 8),

          // Nome do local
          Text(
            'Café Raiz',
            style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
          ),

          SizedBox(height: 32),

          // Input comentário
          TextField(
            controller: _commentController,
            maxLines: 3,
            maxLength: 200,
            decoration: InputDecoration(
              hintText: 'Como foi? (opcional)',
              hintStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Rating
          Text(
            'Avalie sua experiência',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.accent,
                    size: 32,
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 32),

          // Botão Confirmar
          PrimaryButton(
            text: 'Confirmar Check-in',
            onPressed: () => _doCheckIn(),
          ),

          SizedBox(height: 12),

          // Botão Cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    _animController.forward();

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animação de sucesso
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.white, size: 60),
            ),
          ),

          SizedBox(height: 24),

          // Título
          Text(
            'Check-in realizado!',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8),

          // Nome do local
          Text(
            'Café Raiz',
            style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 32),

          // Recompensas
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRewardItem('⭐', '+50', 'Pontos'),
                Container(width: 1, height: 40, color: AppColors.border),
                _buildRewardItem('📍', '+1', 'Visita'),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Badge desbloqueado (condicional)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '🎉 Novo Badge!',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Café Explorer',
                  style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Visitou 5 cafeterias',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),

          // Botão Compartilhar
          PrimaryButton(
            text: 'Compartilhar',
            icon: Icons.share,
            onPressed: () => _share(),
          ),

          SizedBox(height: 12),

          // Botão Fechar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fechar',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: TextStyle(fontSize: 32)),
        SizedBox(height: 8),
        Text(value, style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _doCheckIn() async {
    // Implementar lógica de check-in
    await Future.delayed(Duration(milliseconds: 500));
    setState(() => _showSuccess = true);
  }

  void _share() {
    // Implementar compartilhamento
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _animController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
