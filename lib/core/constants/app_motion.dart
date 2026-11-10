import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const homeNavSelection = medium;
  static const long = Duration(milliseconds: 600);
  static const toastDisplay = Duration(seconds: 3);
  static const homeRefreshSpinLeadIn = Duration(seconds: 1);
  static const homeRefreshSpinPeriod = Duration(seconds: 1);

  static const onboardingHeroEntrance = Duration(milliseconds: 600);
  static const onboardingSlide = Duration(milliseconds: 600);
  static const onboardingHeroStagger = Duration(milliseconds: 80);
  static const onboardingHeroSettledFraction = 0.5;
  static const welcomeHeroSettledFraction = 0.65;
  static const onboardingBottomSlideGate = 0.8;
  static const onboardingBottomEntrance = Duration(milliseconds: 500);
  static const onboardingBottomStagger = Duration(milliseconds: 60);
  static const onboardingBottomDelay = Duration(milliseconds: 200);
  static const onboardingIdlePeriod = Duration(milliseconds: 3500);

  static const onboardingIdleAmplitude = 6.0;
  static const onboardingDriftFactor = 0.12;
  static const onboardingSlideUp = 16.0;

  static const standardCurve = Curves.easeOutCubic;
  static const pressedScale = 0.96;

  /// [duration], or zero when the user asked to reduce motion.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;

  /// Home shell lists: bounce overscroll; clamp when reduce motion is on.
  static ScrollPhysics homeScrollPhysics(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      );
    }
    return const AlwaysScrollableScrollPhysics(
      parent: BouncingScrollPhysics(),
    );
  }
}
