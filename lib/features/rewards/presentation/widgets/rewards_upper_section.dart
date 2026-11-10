import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../catalog/domain/entities/catalog_member.dart';
import '../../domain/rewards_ring_progress.dart';
import '../rewards_entrance_values.dart';
import 'rewards_donut_ring.dart';
import 'rewards_hero_row.dart';
import 'rewards_tier_ladder.dart';

/// Rewards header: title + pill, tier ladder and points ring for one frame.
class RewardsUpperSection extends StatelessWidget {
  const RewardsUpperSection({
    super.key,
    required this.member,
    required this.values,
    required this.badgeScale,
  });

  final CatalogMember member;
  final RewardsEntranceValues values;
  final double badgeScale;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.rewardsBackgroundTop,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RewardsHeroRow(
            pillCount: member.rewardsPillCount,
            badgeScale: badgeScale,
            titleFade: values.titleFade,
            titleSlide: values.titleSlide,
            pillFade: values.sideFade,
            pillSlide: values.sideSlide,
            onPillPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimens.rewardsDonutSectionTopPadding,
            ),
            child: _LadderAndRing(member: member, values: values),
          ),
          const SizedBox(height: AppDimens.rewardsTabsSeamReserve),
        ],
      ),
    );
  }
}

class _LadderAndRing extends StatelessWidget {
  const _LadderAndRing({required this.member, required this.values});

  final CatalogMember member;
  final RewardsEntranceValues values;

  static const _ladderRightInset =
      (AppDimens.rewardsDonutDiameter - AppDimens.rewardsDonutEdgeOverflow) +
      AppDimens.rewardsLadderDonutGap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.rewardsDonutDiameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: _ladderRightInset,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RewardsTierLadder(
                member: member,
                tierOpacities: values.tierFades,
                tierSlides: values.tierSlides,
                connectorFill:
                    values.progress * rewardsRingSweepFraction(member),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(child: _ring()),
          ),
        ],
      ),
    );
  }

  Widget _ring() {
    return RewardsDonutRing(
      ringProgress: values.progress * rewardsDonutRingTarget(member),
      displayedPoints: (member.pointsBalance * values.progress).round(),
      fade: values.sideFade,
      slide: values.sideSlide,
    );
  }
}
