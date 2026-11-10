import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_tier_ladder.dart';

import '../../../../helpers/pump_app.dart';

const _member = CatalogMember(
  displayName: 'T',
  subtitleKey: 'memberSubtitleSilver',
  avatarAsset: 'assets/images/seed/rewards/tier_silver.png',
  tierProgressKey: 'memberTierProgressGold',
  tierProgressKyats: 0,
  notificationCount: 0,
  tierCode: 'silver',
  pointsBalance: 680000,
  pointsToNextTier: 500,
  rewardsPillCount: 3,
  tierLadderFillBp: 7500,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('gold step shows 500 points remaining', (tester) async {
    await tester.pumpApp(
      const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: RewardsTierLadder(
          member: _member,
          tierOpacities: [1, 1, 1],
          tierSlides: [0, 0, 0],
          connectorFill: 0.58,
        ),
      ),
    );

    expect(find.textContaining('500'), findsOneWidget);
  });
}
