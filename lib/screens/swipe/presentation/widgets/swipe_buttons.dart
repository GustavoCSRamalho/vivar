// screens/swipe/widgets/swipe_buttons.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class SwipeButtons extends StatelessWidget {
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onInfo;

  const SwipeButtons({
    Key? key,
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
    required this.onInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Dislike
        _buildButton(
          icon: Icons.close,
          color: AppColors.error,
          size: 60,
          iconSize: 32,
          onTap: onDislike,
        ),

        // Super Like
        _buildButton(
          icon: Icons.star,
          color: AppColors.accent,
          size: 50,
          iconSize: 28,
          onTap: onSuperLike,
        ),

        // Like
        _buildButton(
          icon: Icons.favorite,
          color: AppColors.success,
          size: 60,
          iconSize: 32,
          onTap: onLike,
        ),

        // Info
        _buildButton(
          icon: Icons.info_outline,
          color: AppColors.secondary,
          size: 50,
          iconSize: 28,
          onTap: onInfo,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
