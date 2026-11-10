import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'rewards_donut_ring_painter.dart';

class RewardsDonutRing extends StatelessWidget {
  const RewardsDonutRing({
    super.key,
    required this.ringProgress,
    required this.displayedPoints,
    required this.fade,
    required this.slide,
  });

  final double ringProgress;
  final int displayedPoints;
  final double fade;
  final double slide;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: fade,
      child: Transform.translate(
        offset: Offset(AppDimens.rewardsDonutEdgeOverflow + slide, 0),
        child: SizedBox(
          width: AppDimens.rewardsDonutDiameter,
          height: AppDimens.rewardsDonutDiameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(AppDimens.rewardsDonutDiameter),
                painter: RewardsDonutRingPainter(progress: ringProgress),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.spaceSm),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.rewardsTotalPointsLabel,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.rewardsDonutFrosting,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        NumberFormat('#,###').format(displayedPoints),
                        style: AppTextStyles.headline.copyWith(
                          fontSize: AppDimens.rewardsPointsValueSize,
                          fontWeight: FontWeight.w800,
                          color: AppColors.rewardsDonutFrosting,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
