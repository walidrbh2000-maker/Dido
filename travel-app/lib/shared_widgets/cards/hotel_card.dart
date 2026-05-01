import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';

class HotelCard extends StatelessWidget {
  final HotelEntity hotel;
  final VoidCallback? onTap;

  const HotelCard({super.key, required this.hotel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.borderRadiusLg),
              ),
              child: hotel.image != null
                  ? CachedNetworkImage(
                      imageUrl: hotel.image!,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 160,
                        color: AppColors.shimmerBase,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 160,
                        color: AppColors.shimmerBase,
                        child: const Icon(Icons.hotel, size: 40, color: AppColors.textSecondary),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 160,
                      color: AppColors.shimmerBase,
                      child: const Icon(Icons.hotel, size: 40, color: AppColors.textSecondary),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.nom,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          hotel.etoiles,
                          (_) => const Icon(Icons.star, size: 14, color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    hotel.adresse,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyHelper.format(hotel.prixNuit),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(
                        '/nuit',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
