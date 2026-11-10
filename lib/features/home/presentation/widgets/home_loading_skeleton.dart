import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import 'home_product_section_skeleton.dart';
import 'home_shops_section_skeleton.dart';

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomScrollView(
        physics: AppMotion.homeScrollPhysics(context),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 320,
              decoration: const BoxDecoration(
                color: AppColors.homeHeader,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimens.homeHeaderRadius),
                  bottomRight: Radius.circular(AppDimens.homeHeaderRadius),
                ),
              ),
            ),
          ),
          for (final spec in HomeSectionSkeletonSpec.defaults)
            SliverToBoxAdapter(child: HomeProductSectionSkeleton(spec: spec)),
          const SliverToBoxAdapter(child: HomeShopsSectionSkeleton()),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimens.homeScrollBottomInset),
          ),
        ],
      ),
    );
  }
}
