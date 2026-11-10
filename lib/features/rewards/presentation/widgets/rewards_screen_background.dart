import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class RewardsScreenBackground extends StatelessWidget {
  const RewardsScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppColors.homeScreenBackground, child: child);
  }
}
