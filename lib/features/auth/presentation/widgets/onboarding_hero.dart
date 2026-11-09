import 'dart:math' show min;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_text_styles.dart';

typedef _HeroCircle = ({Alignment alignment, double widthFactor, Color color});

/// Floating donut circles and logo. Circles are colour placeholders until
/// the real donut photos and logo assets are added.
class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key});

  static const List<_HeroCircle> _circles = [
    (
      alignment: Alignment(-1.4, -1.1),
      widthFactor: 0.45,
      color: AppColors.heroCyan,
    ),
    (
      alignment: Alignment(0, -0.85),
      widthFactor: 0.5,
      color: AppColors.heroPeach,
    ),
    (
      alignment: Alignment(1.4, -1.1),
      widthFactor: 0.32,
      color: AppColors.heroPink,
    ),
    (
      alignment: Alignment(-1.45, -0.1),
      widthFactor: 0.4,
      color: AppColors.heroLavender,
    ),
    (
      alignment: Alignment(1.45, -0.15),
      widthFactor: 0.3,
      color: AppColors.heroCyan,
    ),
  ];
  static const _logoAlignment = Alignment(0, 0.75);
  static const _logoWidthFactor = 0.55;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final extent = min(constraints.maxWidth, constraints.maxHeight);
        return ClipRect(
          child: Stack(
            children: [
              for (final circle in _circles)
                Align(
                  alignment: circle.alignment,
                  child: _Circle(
                    diameter: extent * circle.widthFactor,
                    color: circle.color,
                  ),
                ),
              Align(
                alignment: _logoAlignment,
                child: _Circle(
                  diameter: extent * _logoWidthFactor,
                  color: AppColors.heroPink,
                  child: Text(context.l10n.appName, style: AppTextStyles.brand),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.diameter, required this.color, this.child});

  final double diameter;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: child == null ? null : FittedBox(child: child),
    );
  }
}
