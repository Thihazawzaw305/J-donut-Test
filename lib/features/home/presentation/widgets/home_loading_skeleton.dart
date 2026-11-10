import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
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
        SliverPadding(
          padding: const EdgeInsets.all(AppDimens.spaceMd),
          sliver: SliverList.separated(
            itemCount: 4,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimens.spaceLg),
            itemBuilder: (_, _) => const _Bar(height: 120),
          ),
        ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.quantityTrack,
        borderRadius: BorderRadius.circular(AppDimens.homeCardRadius),
      ),
    );
  }
}
