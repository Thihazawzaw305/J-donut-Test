import 'package:flutter/material.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';

/// White scrim on the **bottom half** only.
///
/// Bottom → top opacity: 100, 100, 100, 60, 40, 20, 10, 0.
class WelcomeHeroGradientOverlay extends StatelessWidget {
  const WelcomeHeroGradientOverlay({super.key});

  static const Key overlayKey = Key('welcome_hero_gradient');

  /// Fraction of viewport height covered (lower half).
  static const viewportHeightFraction = 0.5;

  static const List<double> gradientStops = [
    0.0,
    1 / 7,
    2 / 7,
    3 / 7,
    4 / 7,
    5 / 7,
    6 / 7,
    1.0,
  ];

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
              stops: gradientStops,
              colors: AppColors.welcomeScrimColors,
            ),
          ),
        ),
      ),
    );
  }
}
