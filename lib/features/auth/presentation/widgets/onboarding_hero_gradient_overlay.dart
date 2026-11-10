import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// White scrim only: hero stays visible at the top; solid white at the bottom.
class OnboardingHeroGradientOverlay extends StatelessWidget {
  const OnboardingHeroGradientOverlay({super.key});

  static const Key overlayKey = Key('onboarding_hero_gradient');

  static const List<double> gradientStops = [
    0.0,
    0.45,
    0.62,
    0.76,
    1.0,
  ];

  /// Top stays clear; white opacity ramps up toward the bottom only.
  static const List<Color> gradientColors = [
    Color(0x00FFFFFF),
    Color(0x00FFFFFF),
    Color(0x14FFFFFF),
    Color(0x66FFFFFF),
    AppColors.surface,
  ];

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      key: overlayKey,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: gradientStops,
          colors: gradientColors,
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
