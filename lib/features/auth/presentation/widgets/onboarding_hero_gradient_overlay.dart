import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Soft fade: hero stays visible; solid panel color only at the bottom.
class OnboardingHeroGradientOverlay extends StatelessWidget {
  const OnboardingHeroGradientOverlay({super.key});

  static const Key overlayKey = Key('onboarding_hero_gradient');

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      key: overlayKey,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.45, 0.62, 0.76, 1.0],
          colors: [
            Color(0x00FFF7FA),
            Color(0x00FFF7FA),
            Color(0x26FFF7FA),
            Color(0x99FFF7FA),
            AppColors.backgroundBottom,
          ],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
