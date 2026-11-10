import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../catalog/domain/entities/product_card_style.dart';
import '../home_product_card_layout.dart';
import 'home_skeleton_bone.dart';

/// Layout metadata for a horizontal product row skeleton.
class HomeSectionSkeletonSpec {
  const HomeSectionSkeletonSpec({
    required this.sectionId,
    required this.cardStyle,
    this.itemCount = 3,
  });

  final String sectionId;
  final ProductCardStyle cardStyle;
  final int itemCount;

  /// Matches bundled `catalog_v1.json` home sections.
  static const defaults = [
    HomeSectionSkeletonSpec(
      sectionId: 'seasonal',
      cardStyle: ProductCardStyle.largeRect,
      itemCount: 3,
    ),
    HomeSectionSkeletonSpec(
      sectionId: 'popular',
      cardStyle: ProductCardStyle.mediumRect,
      itemCount: 4,
    ),
    HomeSectionSkeletonSpec(
      sectionId: 'orderAgain',
      cardStyle: ProductCardStyle.mediumRect,
      itemCount: 3,
    ),
    HomeSectionSkeletonSpec(
      sectionId: 'donuts',
      cardStyle: ProductCardStyle.square,
      itemCount: 3,
    ),
    HomeSectionSkeletonSpec(
      sectionId: 'bread',
      cardStyle: ProductCardStyle.square,
      itemCount: 2,
    ),
    HomeSectionSkeletonSpec(
      sectionId: 'cookies',
      cardStyle: ProductCardStyle.square,
      itemCount: 2,
    ),
    HomeSectionSkeletonSpec(
      sectionId: 'cake',
      cardStyle: ProductCardStyle.square,
      itemCount: 2,
    ),
  ];
}

class HomeProductSectionSkeleton extends StatelessWidget {
  const HomeProductSectionSkeleton({super.key, required this.spec});

  final HomeSectionSkeletonSpec spec;

  @override
  Widget build(BuildContext context) {
    final listHeight = _listHeight(spec);

    return Padding(
      padding: EdgeInsets.only(
        top: spec.sectionId == 'seasonal'
            ? AppDimens.homeSeasonalSectionTopPadding
            : 0,
        bottom: AppDimens.spaceLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Row(
              children: [
                Expanded(
                  child: HomeSkeletonBone(width: double.infinity, height: 26),
                ),
                SizedBox(width: AppDimens.spaceMd),
                HomeSkeletonBone(
                  width: AppDimens.homeSeeAllButtonSize,
                  height: AppDimens.homeSeeAllButtonSize,
                  radius: AppDimens.homeSeeAllButtonSize / 2,
                ),
              ],
            ),
          ),
          SizedBox(
            height: spec.sectionId == 'seasonal'
                ? AppDimens.homeSeasonalListTopGap
                : AppDimens.spaceMd,
          ),
          SizedBox(
            height: listHeight,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: spec.itemCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimens.spaceMd),
              itemBuilder: (_, _) => _HomeProductTileSkeleton(spec: spec),
            ),
          ),
        ],
      ),
    );
  }

  static double _listHeight(HomeSectionSkeletonSpec spec) {
    final imageHeight = switch (spec.cardStyle) {
      ProductCardStyle.largeRect => AppDimens.homeProductLargeHeight,
      ProductCardStyle.mediumRect
          when HomeProductCardLayout.isMediumFeaturedSection(spec.sectionId) =>
        AppDimens.homeProductPopularHeight,
      ProductCardStyle.mediumRect => AppDimens.homeProductMediumHeight,
      ProductCardStyle.square => AppDimens.homeProductSquareSize,
    };
    return imageHeight + 56;
  }
}

class _HomeProductTileSkeleton extends StatelessWidget {
  const _HomeProductTileSkeleton({required this.spec});

  final HomeSectionSkeletonSpec spec;

  @override
  Widget build(BuildContext context) {
    final size = _cardSize(spec);
    final radius = _cardRadius(spec);

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSkeletonBone(
            width: size.width,
            height: size.height,
            radius: radius,
          ),
          const SizedBox(height: AppDimens.spaceSm),
          HomeSkeletonBone(
            width: size.width * 0.72,
            height: 14,
            radius: 6,
          ),
        ],
      ),
    );
  }

  Size _cardSize(HomeSectionSkeletonSpec spec) => switch (spec.cardStyle) {
    ProductCardStyle.largeRect => const Size(
      AppDimens.homeProductLargeWidth,
      AppDimens.homeProductLargeHeight,
    ),
    ProductCardStyle.mediumRect
        when HomeProductCardLayout.isMediumFeaturedSection(spec.sectionId) =>
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

  double _cardRadius(HomeSectionSkeletonSpec spec) => switch (spec.cardStyle) {
    ProductCardStyle.largeRect => AppDimens.homeProductLargeCardRadius,
    ProductCardStyle.mediumRect
        when HomeProductCardLayout.isMediumFeaturedSection(spec.sectionId) =>
      AppDimens.homeProductPopularCardRadius,
    ProductCardStyle.mediumRect => AppDimens.homeCardRadius,
    ProductCardStyle.square => AppDimens.homeProductSquareCardRadius,
  };
}
