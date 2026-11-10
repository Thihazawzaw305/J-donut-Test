import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../catalog/domain/entities/catalog_shop.dart';
import 'home_shop_card.dart';

class HomeShopsSection extends StatelessWidget {
  const HomeShopsSection({super.key, required this.shops});

  final List<CatalogShop> shops;

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final backgroundHeight = constraints.maxWidth *
            AppDimens.homeShopsBackgroundHeight /
            AppDimens.homeShopsBackgroundWidth;

        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: backgroundHeight),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: constraints.maxWidth,
                height: backgroundHeight,
                child: Image.asset(
                  AppAssets.homeShopsBackground,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.spaceMd,
                      AppDimens.spaceLg,
                      AppDimens.spaceMd,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.l10n.homeShopsNearby(shops.length),
                          style: AppTextStyles.headline.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spaceMd),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => AppToast.show(
                              context,
                              message: context.l10n.comingSoon,
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimens.spaceLg,
                                vertical: AppDimens.spaceMd,
                              ),
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              context.l10n.homeExploreNow,
                              style: AppTextStyles.button.copyWith(
                                color: AppColors.primary,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLg),
                  SizedBox(
                    height: AppDimens.homeShopListHeight,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: shops.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppDimens.spaceMd),
                      itemBuilder: (context, index) =>
                          HomeShopCard(shop: shops[index]),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
