import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/di/catalog_providers.dart';
import '../../../catalog/domain/entities/catalog_challenge.dart';
import 'rewards_challenge_list.dart';
import 'rewards_segmented_tabs.dart';

class RewardsLowerSection extends ConsumerStatefulWidget {
  const RewardsLowerSection({super.key, required this.entrance});

  final Animation<double> entrance;

  @override
  ConsumerState<RewardsLowerSection> createState() =>
      RewardsLowerSectionState();
}

class RewardsLowerSectionState extends ConsumerState<RewardsLowerSection> {
  var _giftSelected = false;

  @override
  Widget build(BuildContext context) {
    final challenges = ref
        .watch(catalogChallengesProvider)
        .maybeWhen(
          data: (value) => value,
          orElse: () => const <CatalogChallenge>[],
        );

    const tabHalf = AppDimens.rewardsSegmentedBarHeight / 2;

    return Expanded(
      child: ColoredBox(
        color: AppColors.homeScreenBackground,
        child: Column(
          children: [
            ClipRect(
              clipBehavior: Clip.none,
              child: SizedBox(
                height: tabHalf,
                child: OverflowBox(
                  maxHeight: AppDimens.rewardsSegmentedBarHeight,
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, -tabHalf),
                    child: RewardsSegmentedTabs(
                      giftSelected: _giftSelected,
                      onGiftSelected: (gift) =>
                          setState(() => _giftSelected = gift),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RewardsChallengeList(
                entrance: widget.entrance,
                challenges: challenges,
                giftSelected: _giftSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
