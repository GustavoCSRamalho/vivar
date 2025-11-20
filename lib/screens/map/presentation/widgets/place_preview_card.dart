// screens/map/widgets/place_preview_card.dart

import 'package:flutter/material.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/domain/entity/map/map_place_entity.dart';

class PlacePreviewCard extends StatelessWidget {
  final MapPlaceEntity place;
  final VoidCallback onTap;

  const PlacePreviewCard({Key? key, required this.place, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(place);
    debugPrint('❌ Ver: Place! ${place.imageUrl}');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.border,
                child: place.imageUrl != null
                    ? Image.asset(place.imageUrl!, fit: BoxFit.cover)
                    : Icon(
                        Icons.image,
                        color: AppColors.textSecondary,
                        size: 32,
                      ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.accent, size: 16),
                          SizedBox(width: 4),
                          Text(
                            place.rating.toString(),
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${place.category}${place.distance != null ? " · ${place.distance}" : ""}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (place.hasDiscount)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF4E6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            place.discount!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (place.hasDiscount) SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: place.isOpen
                              ? Color(0xFFECFDF5)
                              : Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          place.isOpen ? 'Aberto' : 'Fechado',
                          style: AppTextStyles.caption.copyWith(
                            color: place.isOpen
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }
}
