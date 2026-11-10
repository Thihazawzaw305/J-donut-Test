import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import 'home_skeleton_bone.dart';

class HomeShopsSectionSkeleton extends StatelessWidget {
  const HomeShopsSectionSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSkeletonBone(width: 220, height: 30, radius: 8),
                SizedBox(height: AppDimens.spaceMd),
                HomeSkeletonBone(
                  width: 140,
                  height: AppDimens.spaceLg + AppDimens.spaceMd,
                  radius: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          SizedBox(
            height: AppDimens.homeShopCardImageHeight + 80,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceMd),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimens.spaceMd),
              itemBuilder: (_, _) => const _HomeShopCardSkeleton(),
            ),
          ),
          const SizedBox(height: AppDimens.spaceLg),
        ],
      ),
    );
  }
}

class _HomeShopCardSkeleton extends StatelessWidget {
  const _HomeShopCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: AppDimens.homeShopCardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSkeletonBone(
            width: AppDimens.homeShopCardWidth,
            height: AppDimens.homeShopCardImageHeight,
            radius: AppDimens.homeShopCardImageRadius,
          ),
          SizedBox(height: AppDimens.spaceSm),
          HomeSkeletonBone(width: 180, height: 16, radius: 6),
          SizedBox(height: AppDimens.spaceXs),
          HomeSkeletonBone(width: 140, height: 12, radius: 6),
        ],
      ),
    );
  }
}
