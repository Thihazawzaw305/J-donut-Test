import 'package:flutter/material.dart';

import '../../../catalog/domain/entities/catalog_member.dart';
import '../rewards_entrance_values.dart';
import 'rewards_lower_section.dart';
import 'rewards_upper_section.dart';

class RewardsBody extends StatelessWidget {
  const RewardsBody({
    super.key,
    required this.member,
    required this.entrance,
    required this.pillPop,
    required this.badgePop,
  });

  final CatalogMember member;
  final Animation<double> entrance;
  final Animation<double> pillPop;
  final Animation<double> badgePop;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([entrance, pillPop, badgePop]),
          builder: (context, _) => RewardsUpperSection(
            member: member,
            values: RewardsEntranceValues.at(
              entrance.value,
              reduceMotion: reduceMotion,
            ),
            badgeScale: rewardsBadgeScale(badgePop.value),
          ),
        ),
        RewardsLowerSection(entrance: entrance),
      ],
    );
  }
}
