import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'rewards_screen_background.dart';

class RewardsLoadingSkeleton extends StatelessWidget {
  const RewardsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return RewardsScreenBackground(
      child: const Center(
        child: SizedBox(
          width: 200,
          height: 24,
          child: ColoredBox(color: AppColors.skeletonBase),
        ),
      ),
    );
  }
}
