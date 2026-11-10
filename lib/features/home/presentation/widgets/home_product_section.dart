import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../catalog/domain/entities/catalog_section.dart';
import '../../../catalog/domain/entities/product_card_style.dart';
import '../../../catalog/presentation/catalog_strings.dart';
import '../home_product_card_layout.dart';
import 'home_product_tile.dart';

class HomeProductSection extends StatelessWidget {
  const HomeProductSection({super.key, required this.section});

  final CatalogSection section;

  @override
  Widget build(BuildContext context) {
    if (section.products.isEmpty) return const SizedBox.shrink();

    final title = _sectionTitle(context, section);

    return Padding(
      padding: EdgeInsets.only(
        top: _sectionTopPadding(section),
        bottom: AppDimens.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: AppTextStyles.homeSectionTitle),
                ),
                _SeeAllButton(
                  onTap: () => AppToast.show(
                    context,
                    message: context.l10n.comingSoon,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _listTopGap(section)),
          SizedBox(
            height: _listHeight(section),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              scrollDirection: Axis.horizontal,
              itemCount: section.products.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppDimens.spaceMd),
              itemBuilder: (context, index) => HomeProductTile(
                product: section.products[index],
                cardStyle: section.cardStyle,
                sectionId: section.id,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _sectionTopPadding(CatalogSection section) =>
      section.id == 'seasonal' ? AppDimens.homeSeasonalSectionTopPadding : 0;

  double _listTopGap(CatalogSection section) => section.id == 'seasonal'
      ? AppDimens.homeSeasonalListTopGap
      : AppDimens.spaceMd;

  double _listHeight(CatalogSection section) {
    final imageHeight = switch (section) {
      CatalogSection(cardStyle: ProductCardStyle.largeRect) =>
        AppDimens.homeProductLargeHeight,
      CatalogSection(
        id: final id,
        cardStyle: ProductCardStyle.mediumRect,
      )
          when HomeProductCardLayout.isMediumFeaturedSection(id) =>
        AppDimens.homeProductPopularHeight,
      CatalogSection(cardStyle: ProductCardStyle.mediumRect) =>
        AppDimens.homeProductMediumHeight,
      CatalogSection(cardStyle: ProductCardStyle.square) =>
        AppDimens.homeProductSquareSize,
    };
    return imageHeight + 56;
  }

  String _sectionTitle(BuildContext context, CatalogSection section) {
    final base = catalogString(context.l10n, section.titleKey);
    return switch (section.id) {
      'popular' => '$base 🔥',
      'seasonal' => '$base 💕',
      _ => base,
    };
  }
}

class _SeeAllButton extends StatelessWidget {
  const _SeeAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: AppDimens.homeSeeAllButtonSize,
          height: AppDimens.homeSeeAllButtonSize,
          child: Icon(
            Icons.chevron_right,
            size: AppDimens.homeSeeAllIconSize,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
