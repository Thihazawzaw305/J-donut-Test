import 'dart:ui' show lerpDouble;

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_motion.dart';

/// Circular donut tile. [dx] is the centre offset from the screen middle as a
/// fraction of width, [dy] the centre as a fraction of height at the start,
/// [size] the diameter as a fraction of width.
class OnboardingDonutTile {
  const OnboardingDonutTile({
    required this.asset,
    required this.dx,
    required this.dy,
    required this.size,
  });

  final String asset;
  final double dx;
  final double dy;
  final double size;
}

/// Upward travel of the whole group, as a fraction of screen height.
const onboardingGroupShift = -0.52;

const onboardingLogoStartDy = 0.42;
const onboardingLogoEndDy = 0.5;
const _logoFadeMidpoint = 0.5;

/// Group offset (fraction of height) at timeline [progress] in [0, 1].
double onboardingGroupOffset(double progress) =>
    onboardingGroupShift * AppMotion.standardCurve.transform(progress);

/// Logo fades out for the first half of the move, then back in.
double onboardingLogoOpacity(double progress) =>
    ((progress - _logoFadeMidpoint).abs() / _logoFadeMidpoint).clamp(0.0, 1.0);

double onboardingLogoDy(double progress) => lerpDouble(
  onboardingLogoStartDy,
  onboardingLogoEndDy,
  AppMotion.standardCurve.transform(progress),
)!;

const _tileSize = 0.53;

/// Back-to-front paint order; the center tile is last.
const onboardingDonutTiles = <OnboardingDonutTile>[
  OnboardingDonutTile(
    asset: AppAssets.onboardingDonutChocolate,
    dx: -0.63,
    dy: 0.56,
    size: 0.65,
  ),
  OnboardingDonutTile(
    asset: AppAssets.onboardingDonutCheerful,
    dx: -0.57,
    dy: 0.845,
    size: _tileSize,
  ),
  OnboardingDonutTile(
    asset: AppAssets.onboardingDonutBadge,
    dx: 0.61,
    dy: 0.56,
    size: _tileSize,
  ),
  OnboardingDonutTile(
    asset: AppAssets.onboardingDonutPink,
    dx: 0.625,
    dy: 0.84,
    size: _tileSize,
  ),
  OnboardingDonutTile(
    asset: AppAssets.onboardingDonutCenter,
    dx: 0,
    dy: 0.71,
    size: _tileSize,
  ),
];
