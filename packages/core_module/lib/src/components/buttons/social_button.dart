// widgets/social_button.dart
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../constants/spacing.dart';

class SocialButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SocialButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: backgroundColor == Colors.white
            ? Border.all(color: AppColors.border)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon, width: 24, height: 24),
              SizedBox(width: 12),
              Text(
                text,
                style: AppTextStyles.button.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
