import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// White scrim on the **bottom half** only.
///
/// Bottom → top opacity: 100, 100, 100, 60, 40, 20, 10, 0.
class WelcomeHeroGradientOverlay extends StatelessWidget {
  const WelcomeHeroGradientOverlay({super.key});

  static const Key overlayKey = Key('welcome_hero_gradient');

  /// Fraction of viewport height covered (lower half).
  static const viewportHeightFraction = 0.5;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * viewportHeightFraction;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        key: overlayKey,
        width: double.infinity,
        height: height,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: AppColors.welcomeScrimStops,
              colors: AppColors.welcomeScrimColors,
            ),
          ),
        ),
      ),
    );
  }
}
