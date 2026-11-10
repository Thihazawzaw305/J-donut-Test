import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/domain/entities/catalog_product.dart';
import '../../../catalog/domain/entities/product_card_style.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../home_product_card_layout.dart';

class HomeProductTile extends StatelessWidget {
  const HomeProductTile({
    super.key,
    required this.product,
    required this.cardStyle,
    this.sectionId,
  });

  final CatalogProduct product;
  final ProductCardStyle cardStyle;
  final String? sectionId;

  @override
  Widget build(BuildContext context) {
    final size = _cardSize(cardStyle, sectionId);
    final radius = _cardRadius(cardStyle, sectionId);
    final name = catalogString(context.l10n, product.nameKey);
    final duration = AppMotion.of(context, AppMotion.medium);

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OpenContainer<void>(
            transitionDuration: duration,
            openElevation: 0,
            closedElevation: 2,
            closedColor: AppColors.surface,
            openColor: AppColors.homeScreenBackground,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            openShape: const RoundedRectangleBorder(),
            tappable: false,
            closedBuilder: (context, open) {
              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(radius),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: open,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height,
                        child: CatalogImage(
                          asset: product.imageAsset,
                          networkUrl: product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (product.discountPercent != null)
                        Positioned(
                          top: AppDimens.spaceSm,
                          left: AppDimens.spaceSm,
                          child: _Badge(
                            label: context.l10n.discountBadge(
                              product.discountPercent!,
                            ),
                          ),
                        ),
                      if (product.isNew)
                        Positioned(
                          top: AppDimens.spaceSm,
                          right: AppDimens.spaceSm,
                          child: _Badge(label: context.l10n.productNewBadge),
                        ),
                    ],
                  ),
                ),
              );
            },
            openBuilder: (context, _) =>
                ProductDetailPage(productId: product.id),
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(
            name,
            style: AppTextStyles.bodyBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double _cardRadius(ProductCardStyle style, String? sectionId) =>
      switch (style) {
        ProductCardStyle.largeRect => AppDimens.homeProductLargeCardRadius,
        ProductCardStyle.mediumRect
            when HomeProductCardLayout.isMediumFeaturedSection(sectionId ?? '') =>
          AppDimens.homeProductPopularCardRadius,
        ProductCardStyle.mediumRect => AppDimens.homeCardRadius,
        ProductCardStyle.square => AppDimens.homeProductSquareCardRadius,
      };

  Size _cardSize(ProductCardStyle style, String? sectionId) => switch (style) {
    ProductCardStyle.largeRect => const Size(
      AppDimens.homeProductLargeWidth,
      AppDimens.homeProductLargeHeight,
    ),
    ProductCardStyle.mediumRect
        when HomeProductCardLayout.isMediumFeaturedSection(sectionId ?? '') =>
        const Size(
      AppDimens.homeProductPopularWidth,
      AppDimens.homeProductPopularHeight,
    ),
    ProductCardStyle.mediumRect => const Size(
      AppDimens.homeProductMediumWidth,
      AppDimens.homeProductMediumHeight,
    ),
    ProductCardStyle.square => const Size(
      AppDimens.homeProductSquareSize,
      AppDimens.homeProductSquareSize,
    ),
  };
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

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
