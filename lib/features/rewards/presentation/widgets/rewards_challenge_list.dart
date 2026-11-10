import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_motion.dart';
import '../../../catalog/domain/entities/catalog_challenge.dart';
import '../../../home/presentation/home_scroll_layout.dart';
import 'rewards_challenge_card.dart';
import 'rewards_challenge_entrance.dart';
import 'rewards_gift_empty.dart';

class RewardsChallengeList extends StatelessWidget {
  const RewardsChallengeList({
    super.key,
    required this.entrance,
    required this.challenges,
    required this.giftSelected,
  });

  final Animation<double> entrance;
  final List<CatalogChallenge> challenges;
  final bool giftSelected;

  @override
  Widget build(BuildContext context) {
    final tab = giftSelected
        ? CatalogChallengeTab.gift
        : CatalogChallengeTab.eat;
    final items = [
      for (final c in challenges)
        if (c.tab == tab) c,
    ];

    return ColoredBox(
      color: AppColors.homeScreenBackground,
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.rewardsTabListSwitch),
        child: items.isEmpty
            ? RewardsGiftEmpty(key: ValueKey('empty-$tab'))
            : ListView.separated(
                key: ValueKey('list-$tab'),
                physics: AppMotion.homeScrollPhysics(context),
                padding: EdgeInsets.fromLTRB(
                  AppDimens.spaceMd,
                  AppDimens.rewardsChallengeListTopPadding,
                  AppDimens.spaceMd,
                  homeScrollBottomClearance(context),
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppDimens.rewardsChallengeListGap),
                itemBuilder: (context, index) {
                  final challenge = items[index];
                  return RewardsChallengeEntrance(
                    entrance: entrance,
                    index: index,
                    child: RewardsChallengeCard(
                      key: ValueKey(challenge.id),
                      challenge: challenge,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
