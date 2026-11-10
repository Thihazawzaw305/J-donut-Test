import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';
import 'product_quantity_stepper.dart';

class ProductDetailHeroCard extends StatelessWidget {
  const ProductDetailHeroCard({
    super.key,
    required this.productId,
    required this.productCode,
    required this.name,
    required this.unitPriceLabel,
    required this.imageAsset,
    this.imageUrl,
    required this.showNewBadge,
    required this.newBadgeLabel,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String productId;
  final String productCode;
  final String name;
  final String unitPriceLabel;
  final String imageAsset;
  final String? imageUrl;
  final bool showNewBadge;
  final String newBadgeLabel;
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.homeCardRadius),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.spaceLg,
                  top: AppDimens.spaceLg,
                  right: AppDimens.spaceLg,
                  bottom:
                      AppDimens.spaceLg + AppDimens.productDetailStepperOverlap,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(productCode, style: AppTextStyles.caption),
                        const Spacer(),
                        if (showNewBadge) _NewBadge(label: newBadgeLabel),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spaceSm),
                    Text(name, style: AppTextStyles.headline),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(unitPriceLabel, style: AppTextStyles.bodyBold),
                    const SizedBox(height: AppDimens.spaceLg),
                    Center(
                      child: SizedBox(
                        width: AppDimens.productDetailImageWidth,
                        height: AppDimens.productDetailImageHeight,
                        child: Hero(
                          tag: 'product-image-$productId',
                          child: CatalogImage(
                            asset: imageAsset,
                            networkUrl: imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.productDetailStepperOverlap),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: ProductQuantityStepper(
              quantity: quantity,
              onDecrease: onDecrease,
              onIncrease: onIncrease,
            ),
          ),
        ),
      ],
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.notificationOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceXs,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}
