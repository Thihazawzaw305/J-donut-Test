abstract final class AppDimens {
  static const spaceXs = 4.0;
  static const spaceSm = 8.0;
  static const spaceMd = 16.0;
  static const spaceLg = 24.0;
  static const spaceXl = 32.0;

  static const screenPadding = 32.0;
  static const onboardingPadding = 20.0;
  static const welcomeDonutTileSize = 72.0;
  static const welcomeDonutTileRadius = 16.0;

  static const buttonHeight = 52.0;
  static const inputHeight = 68.0;
  static const inputRadius = 10.0;
  static const backButtonSize = 40.0;
  static const backButtonRadius = 10.0;
  static const progressRingSize = 40.0;
  static const progressRingStroke = 9.0;
  static const otpBoxSize = 48.0;
  static const otpBoxGap = 8.0;
  static const otpBoxRadius = 10.0;
  static const socialButtonSize = 48.0;
  static const socialButtonElevation = 4.0;
  static const toastRadius = 16.0;
  static const toastElevation = 6.0;
  static const spinnerSize = 22.0;
  static const spinnerStroke = 2.5;
  static const datePickerHeight = 216.0;
  static const iconMd = 24.0;
  static const iconLg = 32.0;
  static const shadowBlur = 12.0;

  static const homeHeaderRadius = 32.0;
  static const homeBannerRadius = 20.0;
  static const homeCardRadius = 20.0;
  static const homeNavRadius = 20.0;
  static const homeNavHeight = 80.0;
  static const homeNavPillBorderWidth = 1.0;
  static const homeNavPillPaddingH = 13.0;
  static const homeNavPillPaddingV = 10.0;
  /// Stadium capsule; larger than pill height for fully rounded ends.
  static const homeNavPillRadius = 32.0;
  /// Clearance between scrollable shell content and the floating nav.
  static const homeNavContentGap = 16.0;
  /// Trailing gap after the last home scroll section.
  static const homeScrollBottomInset = 25.0;
  static const homeProductLargeWidth = 252.0;
  static const homeProductLargeHeight = 160.0;
  static const homeProductLargeCardRadius = 12.0;
  static const homeSeasonalListTopGap = 24.0;
  static const homeSeasonalSectionTopPadding = 24.0;
  static const homeProductMediumWidth = 132.0;
  static const homeProductMediumHeight = 168.0;
  /// Popular + Order again medium rows.
  static const homeProductPopularWidth = 144.0;
  static const homeProductPopularHeight = 200.0;
  static const homeProductPopularCardRadius = 12.0;
  static const homeProductSquareSize = 136.0;
  static const homeProductSquareCardRadius = 12.0;
  static const homeSectionTitleSize = 22.0;
  static const homeSeeAllButtonSize = 32.0;
  static const homeSeeAllIconSize = 20.0;
  static const homeRefreshDonutSize = 44.0;
  static const homeRefreshTriggerPull = 84.0;
  static const homeRefreshIndicatorExtent = 60.0;
  static const homeShopsBackgroundWidth = 682.0;
  static const homeShopsBackgroundHeight = 1024.0;
  static const homeShopCardWidth = 300.0;
  static const homeShopCardImageHeight = 168.0;
  static const homeShopCardImageRadius = 12.0;
  static const homeShopCardRadius = 20.0;
  static const homeBannerHeight = 180.0;
  static const homeBannerViewportFraction = 0.86;
  static const homeBannerVirtualPageCount = 10000;

  static const homeNotificationHeight = 36.0;
  static const homeNotificationMinWidth = 60.0;
  static const homeNotificationBorderWidth = 1.5;
  static const homeNotificationRadius = 18.0;
  /// Below safe area; aligned with profile row after [homeHeaderTopPadding].
  static const homeNotificationTopOffset =
      homeHeaderTopPadding + spaceSm;
  static const homeNotificationLayoutReserve =
      homeNotificationMinWidth + spaceSm;

  static const homeTierPillRadius = 20.0;
  static const homeTierPillPaddingH = 12.0;
  static const homeTierPillPaddingV = 6.0;
  static const homeHeaderTopPadding = 40.0;
  static const homeHeaderGapProfileToPill = 14.0;
  static const homeHeaderGapPillToBanner = 24.0;
  static const homeHeaderPaddingBottom = 0.0;

  /// Profile, tier pill, gaps, and banner — excludes top safe inset.
  static const homeHeaderExpandedBodyHeight = 354.0;

  /// Upward slide distance when the home header fully collapses.
  static const homeHeaderCollapseShift = 28.0;

  static const productDetailImageWidth = 252.0;
  static const productDetailImageHeight = 252.0;
  static const productDetailStepperOverlap = 24.0;
  static const productDetailHelpColumnWidth = 88.0;
  static const productDetailHelpDividerWidth = 1.0;

  static const rewardsDonutDiameter = 260.0;
  static const rewardsDonutStroke = 58.0;
  /// How far the donut extends past the right screen edge (logical px).
  static const rewardsDonutEdgeOverflow = 32.0;
  /// Space between tier ladder and the donut ring (on-screen).
  static const rewardsLadderDonutGap = 20.0;
  /// Lifts tier ladder + donut ring upward in the body area.
  static const rewardsMainContentLift = 140.0;
  static const rewardsDonutDisplaySweep = 0.75;
  /// Arc starts near 8 o'clock, then fills through the bottom (negative sweep).
  static const rewardsDonutArcStart = 2.617993878; // 5π/6
  static const rewardsDonutSweepSign = -1.0;
  static const rewardsDonutSprinkleLength = 20.0;
  static const rewardsDonutSprinkleThickness = 4.8;
  static const rewardsTierBadgeSize = 42.0;
  /// Locked tier badges: 0 = full color, 1 = fully desaturated.
  static const rewardsTierLockedDesaturateGold = 0.35;
  static const rewardsTierLockedDesaturatePlatinum = 0.48;
  static const rewardsTierLockedOpacityGold = 0.92;
  static const rewardsTierLockedOpacityPlatinum = 0.8;
  static const rewardsTierConnectorWidth = 3.0;
  static const rewardsTierConnectorHeight = 48.0;
  static const rewardsTierStepGap = 8.0;
  static const rewardsSegmentedBarHeight = 48.0;
  static const rewardsSegmentedThumbRadius = 24.0;
  static const rewardsSegmentedMaxWidth = 360.0;
  static const rewardsScreenTitleSize = 22.0;
  static const rewardsPointsValueSize = 28.0;
  static const rewardsPillRadius = 22.0;
  static const rewardsPillCountBadgeSize = 20.0;
  static const rewardsPillPaddingH = 14.0;
  static const rewardsPillPaddingV = 8.0;
  static const rewardsPillBorderWidth = 1.0;
  static const rewardsBackgroundTopFraction = 1 / 2;
}
