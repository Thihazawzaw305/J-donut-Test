import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';

/// White gradient panel that rises from the bottom behind the CTA block.
class OnboardingBottomGradient extends StatelessWidget {
  const OnboardingBottomGradient({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final total =
        AppMotion.onboardingBottomDelay + AppMotion.onboardingGradientEntrance;
    final duration = AppMotion.of(context, total);
    final start =
        AppMotion.onboardingBottomDelay.inMilliseconds / total.inMilliseconds;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Interval(start, 1, curve: AppMotion.standardCurve),
      builder: (context, t, child) =>
          FractionalTranslation(translation: Offset(0, 1 - t), child: child),
      child: DecoratedBox(
        key: const Key('onboarding_bottom_gradient'),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.onboardingBottomFade,
            stops: AppColors.onboardingBottomFadeStops,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: AppDimens.onboardingGradientFade),
          child: child,
        ),
      ),
    );
  }
}
