import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../catalog/domain/entities/catalog_shop.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../../../catalog/presentation/widgets/catalog_image.dart';

class HomeShopCard extends StatelessWidget {
  const HomeShopCard({super.key, required this.shop});

  final CatalogShop shop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.homeShopCardWidth,
      child: Material(
        color: AppColors.surface,
        elevation: 3,
        shadowColor: AppColors.shadow,
        borderRadius: BorderRadius.circular(AppDimens.homeShopCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimens.homeShopCardImageRadius,
                ),
                child: SizedBox(
                  height: AppDimens.homeShopCardImageHeight,
                  child: CatalogImage(
                    asset: shop.imageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Text(
                catalogString(context.l10n, shop.nameKey),
                style: AppTextStyles.homeShopCardTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimens.spaceXs),
              Text(
                catalogString(context.l10n, shop.addressKey),
                style: AppTextStyles.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimens.spaceSm),
              Text(context.l10n.homeOrderOnline, style: AppTextStyles.link),
            ],
          ),
        ),
      ),
    );
  }
}
