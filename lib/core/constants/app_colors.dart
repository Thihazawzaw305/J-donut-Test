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

  static const homeHeader = heroPeach;
  static const homeScreenBackground = Color(0xFFF5F6F8);
  static const notificationOrange = Color(0xFFF5A623);
  static const homeNavBar = primary;
  static const homeNavActive = accent;
  static const homeShopsSky = Color(0xFFB8ECF8);
  static const homeShopsGrass = Color(0xFF8FD14F);
  static const productHelpGreen = Color(0xFF8BC34A);
  static const quantityTrack = Color(0xFFE8E8EA);
  static const tierCapsuleBorder = Color(0xFFE2E2E6);
}
