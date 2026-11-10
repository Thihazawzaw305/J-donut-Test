import 'package:flutter/painting.dart';

/// Brand palette sampled from the J'Donuts designs.
abstract final class AppColors {
  static const primary = Color(0xFF32C4E9);
  static const primaryDisabled = Color(0x8032C4E9);
  static const onPrimary = Color(0xFFFFFFFF);
  static const accent = Color(0xFFF2559A);
  static const otpCursor = primary;
  static const ringProgress = Color(0xFFFF4C9E);
  static const ringTrack = Color(0xFF61D3F8);
  static const backgroundTop = Color(0xFFFFD6E6);
  static const backgroundMiddle = Color(0xFFFFECF2);
  static const backgroundBottom = Color(0xFFFFF7FA);
  static const inputBorderIdle = Color(0x00000000);
  static const inputBorderFocused = primary;
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1E1E22);
  static const textHint = Color(0xFF999999);
  static const textMuted = Color(0xFF787677);
  static const error = Color(0xFFE5484D);
  static const shadow = Color(0x14000000);
  static const facebookBlue = Color(0xFF1877F2);
  static const heroCyan = Color(0xFFB8ECF8);
  static const heroPink = Color(0xFFFFD9E8);
  static const heroLavender = Color(0xFFDCD6FF);
  static const heroPeach = Color(0xFFFCE3D6);

  static const authGradient = [
    backgroundTop,
    backgroundMiddle,
    backgroundBottom,
  ];
  static const onboardingGradient = [surface, backgroundBottom];
  static const surfaceClear = Color(0x00FFFFFF);
  static const onboardingBottomFade = [surfaceClear, surface, surface];
  static const onboardingBottomFadeStops = [0.0, 0.3, 1.0];

  /// Welcome hero scrim, top → bottom: white at 0, 10, 20, 40, 60, 100% alpha.
  static const welcomeScrimColors = [
    surfaceClear,
    Color(0x1AFFFFFF),
    Color(0x33FFFFFF),
    Color(0x66FFFFFF),
    Color(0x99FFFFFF),
    surface,
    surface,
    surface,
  ];

  static const homeHeader = heroPeach;
  static const homeScreenBackground = Color(0xFFEBEDF0);
  static const notificationOrange = Color(0xFFF5A623);
  static const homeNavBar = primary;
  static const homeNavActive = accent;
  static const homeShopsSky = Color(0xFFB8ECF8);
  static const homeShopsGrass = Color(0xFF8FD14F);
  static const productHelpGreen = Color(0xFF8BC34A);
  static const quantityTrack = Color(0xFFE8E8EA);
  static const skeletonBase = Color(0xFFC9C9CE);
  static const skeletonHighlight = Color(0xFFDCDCE0);
  static const tierCapsuleBorder = Color(0xFFE2E2E6);
  static const rewardsDonutTrack = Color(0xFFE6E6EA);
  static const rewardsDonutFrosting = Color(0xFFFF5AA8);
  static const rewardsDonutFrostingHi = Color(0xFFFF9AC8);
  static const rewardsDonutFrostingMid = Color(0xFFFF6EB4);
  static const rewardsDonutFrostingLo = Color(0xFFF04098);
  static const rewardsDonutSprinkle = Color(0xFFFFD6E8);
  static const rewardsConnectorFill = Color(0xFF3D3D42);
  static const rewardsConnectorTrack = Color(0xFFD8D8DD);
  static const rewardsBackgroundTop = Color(0xFFFAFBFC);
  static const rewardsSegmentedUnselected = rewardsBackgroundTop;
  static const rewardsEarnInactive = Color(0xFFC8C8CD);
  static const rewardsCoffeeArc = Color(0xFFFF7A18);
  static const rewardsCoffeeArcTrack = Color(0xFFE4E4E8);
}
