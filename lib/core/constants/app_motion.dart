import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const short = Duration(milliseconds: 150);
  static const medium = Duration(milliseconds: 300);
  static const productDetailContainer = Duration(milliseconds: 450);
  static const homeNavSelection = medium;
  static const long = Duration(milliseconds: 600);
  static const stepCheckDraw = Duration(milliseconds: 400);
  static const toastDisplay = Duration(seconds: 3);
  static const homeRefreshSpinLeadIn = Duration(seconds: 1);
  static const homeRefreshSpinPeriod = Duration(seconds: 1);
  static const homeShimmerPeriod = Duration(milliseconds: 1400);
  static const homeBannerAutoAdvance = Duration(seconds: 4);
  static const homeSectionEntrance = Duration(milliseconds: 400);
  static const homeSectionEntranceStagger = Duration(milliseconds: 60);

  static const rewardsEntrance = Duration(milliseconds: 500);
  static const rewardsEntranceOffset = 24.0;
  static const rewardsTitleInterval = Interval(0, 0.4, curve: standardCurve);
  static const rewardsSideInterval = Interval(0.15, 0.55, curve: standardCurve);
  static const rewardsRingSweep = Duration(milliseconds: 1400);
  static const rewardsPillPop = Duration(milliseconds: 320);
  static const rewardsTabThumb = Duration(milliseconds: 280);
  static const rewardsCardEntrance = Duration(milliseconds: 420);

  /// Stagger step on the shared [0, 1] rewards entrance for list cards.
  static const rewardsCardStaggerStep = 0.1;
  static const rewardsCardEntranceSpan = 0.28;
  static const rewardsEarnPulse = Duration(milliseconds: 900);
  static const rewardsTabListSwitch = Duration(milliseconds: 280);

  static const welcomeDonutStagger = Duration(milliseconds: 70);
  static const welcomeDonutEntrance = Duration(milliseconds: 450);
  /// Starts after the last of 4 tiles settles: stagger * 3 + entrance.
  static const welcomeTitleDelay = Duration(milliseconds: 660);
  static const welcomeTileSlide = 48.0;
  static const welcomeTitleEntrance = Duration(milliseconds: 500);

  static const onboardingHeroEntrance = Duration(milliseconds: 600);
  static const onboardingSlide = Duration(milliseconds: 600);
  static const onboardingHeroStagger = Duration(milliseconds: 80);
  static const onboardingHeroSettledFraction = 0.5;
  static const welcomeHeroSettledFraction = 0.65;
  static const onboardingBottomSlideGate = 0.8;
  static const onboardingBottomEntrance = Duration(milliseconds: 500);
  static const onboardingBottomStagger = Duration(milliseconds: 60);
  static const onboardingBottomDelay = Duration(milliseconds: 200);

  /// Hero donuts: hold stacked, then move up together with the bottom block.
  static const onboardingHeroHold = onboardingBottomDelay;
  static const onboardingHeroMove = Duration(milliseconds: 1300);
  static const onboardingGradientEntrance = Duration(milliseconds: 700);
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
    return const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
  }
}
