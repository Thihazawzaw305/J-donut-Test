import '../../../core/constants/app_motion.dart';

/// Opacity and offset of each Rewards header element at one entrance instant.
class RewardsEntranceValues {
  const RewardsEntranceValues._({
    required this.progress,
    required this.tierFades,
    required this.tierSlides,
    required this.sideFade,
    required this.sideSlide,
    required this.titleFade,
    required this.titleSlide,
  });

  /// Values at entrance time [t] (0–1). Reduce Motion skips to the end state.
  factory RewardsEntranceValues.at(double t, {required bool reduceMotion}) {
    if (reduceMotion) return _settled;
    final tierFades = [
      for (final interval in AppMotion.rewardsTierIntervals)
        interval.transform(t),
    ];
    final sideFade = AppMotion.rewardsSideInterval.transform(t);
    final titleFade = AppMotion.rewardsTitleInterval.transform(t);
    return RewardsEntranceValues._(
      progress: t,
      tierFades: tierFades,
      tierSlides: [for (final fade in tierFades) _slideFor(fade)],
      sideFade: sideFade,
      sideSlide: _slideFor(sideFade),
      titleFade: titleFade,
      titleSlide: _slideFor(titleFade),
    );
  }

  static const _settled = RewardsEntranceValues._(
    progress: 1,
    tierFades: [1, 1, 1],
    tierSlides: [0, 0, 0],
    sideFade: 1,
    sideSlide: 0,
    titleFade: 1,
    titleSlide: 0,
  );

  /// Drives the points count-up, ring sweep and ladder connector fill.
  final double progress;
  final List<double> tierFades;
  final List<double> tierSlides;

  /// Points ring and rewards pill (right-hand side).
  final double sideFade;
  final double sideSlide;
  final double titleFade;
  final double titleSlide;

  static double _slideFor(double fade) =>
      (1 - fade) * AppMotion.rewardsEntranceOffset;
}

/// Rewards badge scale for pop-in progress [pop] (0–1).
double rewardsBadgeScale(double pop) =>
    AppMotion.rewardsBadgeRestScale +
    (1 - AppMotion.rewardsBadgeRestScale) * pop;
