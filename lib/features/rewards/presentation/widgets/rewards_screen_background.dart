import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';

class RewardsScreenBackground extends StatelessWidget {
  const RewardsScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final stop = AppDimens.rewardsBackgroundTopFraction;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            AppColors.rewardsBackgroundTop,
            AppColors.rewardsBackgroundTop,
            AppColors.homeScreenBackground,
            AppColors.homeScreenBackground,
          ],
          stops: [0, stop, stop, 1],
        ),
      ),
      child: child,
    );
  }
}
