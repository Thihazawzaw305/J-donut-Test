import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../catalog/domain/entities/catalog_member.dart';
import '../../domain/rewards_tier.dart';
import 'rewards_tier_step.dart';

class RewardsTierLadder extends StatelessWidget {
  const RewardsTierLadder({
    super.key,
    required this.member,
    required this.tierOpacities,
    required this.tierSlides,
    required this.connectorFill,
  });

  final CatalogMember member;
  final List<double> tierOpacities;
  final List<double> tierSlides;
  final double connectorFill;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final points = NumberFormat('#,###').format(member.pointsToNextTier);
    final fill = connectorFill.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.spaceMd,
        right: AppDimens.spaceXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RewardsTierStep(
            tier: RewardsTier.silver,
            title: l10n.rewardsTierSilverTitle,
            subtitle: l10n.rewardsTierSilverSubtitleHere,
            reached: isTierReached(member.tierCode, RewardsTier.silver),
            fade: tierOpacities[0],
            slide: tierSlides[0],
            showConnectorBelow: true,
            belowConnectorFill: fill,
          ),
          RewardsTierStep(
            tier: RewardsTier.gold,
            title: l10n.rewardsTierGoldTitle,
            subtitle: l10n.rewardsTierGoldSubtitlePoints(points),
            reached: isTierReached(member.tierCode, RewardsTier.gold),
            fade: tierOpacities[1],
            slide: tierSlides[1],
            showConnectorBelow: true,
            belowConnectorFill: 0,
          ),
          RewardsTierStep(
            tier: RewardsTier.platinum,
            title: l10n.rewardsTierPlatinumTitle,
            subtitle: l10n.rewardsTierPlatinumSubtitleSoon,
            reached: isTierReached(member.tierCode, RewardsTier.platinum),
            fade: tierOpacities[2],
            slide: tierSlides[2],
          ),
        ],
      ),
    );
  }
}
