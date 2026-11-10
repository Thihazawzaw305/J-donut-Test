import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';

/// Staggered fade + slide from the left, driven by [entrance] (rewards tab reveal).
class RewardsChallengeEntrance extends StatelessWidget {
  const RewardsChallengeEntrance({
    super.key,
    required this.entrance,
    required this.index,
    required this.child,
  });

  final Animation<double> entrance;
  final int index;
  final Widget child;

  static double _intervalStart(int index) {
    return (0.4 + index * AppMotion.rewardsCardStaggerStep).clamp(0.0, 0.85);
  }

  static double _intervalEnd(int index) {
    return (_intervalStart(index) + AppMotion.rewardsCardEntranceSpan)
        .clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return AnimatedBuilder(
      animation: entrance,
      builder: (context, child) {
        final curve = Interval(
          _intervalStart(index),
          _intervalEnd(index),
          curve: AppMotion.standardCurve,
        );
        final t = curve.transform(entrance.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(-AppMotion.rewardsEntranceOffset * (1 - t), 0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
