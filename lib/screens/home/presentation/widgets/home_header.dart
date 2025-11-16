// screens/home/widgets/home_header.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/constants/spacing.dart';

class HomeHeader extends StatelessWidget {
  final String location;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final bool hasUnreadNotifications;

  const HomeHeader({
    Key? key,
    required this.location,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onSearchTap,
    required this.onFilterTap,
    this.hasUnreadNotifications = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.horizontalPadding),
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Localização e Notificações
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary, size: 20),
                SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: onLocationTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            location,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_outlined),
                      onPressed: onNotificationTap,
                    ),
                    if (hasUnreadNotifications)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12),

            // Barra de busca
            GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.search, color: AppColors.textSecondary),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Buscar lugares, experiências...',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune, color: AppColors.textSecondary),
                      onPressed: onFilterTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
