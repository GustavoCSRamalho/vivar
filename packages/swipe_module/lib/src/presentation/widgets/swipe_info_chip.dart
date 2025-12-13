// screens/swipe/widgets/swipe_info_chip.dart
import 'package:core_module/core_module.dart';
import 'package:flutter/material.dart';

class SwipeInfoChip extends StatelessWidget {
  final int remainingCount;
  final VoidCallback onInfoTap;

  const SwipeInfoChip({
    Key? key,
    required this.remainingCount,
    required this.onInfoTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.explore, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                '$remainingCount lugares para descobrir',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onInfoTap,
            child: Icon(
              Icons.help_outline,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
