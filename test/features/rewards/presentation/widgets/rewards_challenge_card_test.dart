import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_colors.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_challenge.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_challenge_card.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_challenge_list.dart';
import 'package:j_donuts_app/features/rewards/presentation/widgets/rewards_earn_button.dart';

import '../../../../helpers/pump_app.dart';

const _complete = CatalogChallenge(
  id: 'c_coco_complete',
  tab: CatalogChallengeTab.eat,
  kind: CatalogChallengeKind.donut,
  titleKey: 'challengeEatCocoDonuts',
  progressCurrent: 4,
  progressTotal: 4,
  pointsReward: 100,
  imageAsset: 'assets/images/seed/rewards/challenge_coco_full.jpg',
  sortOrder: 0,
);

const _quarter = CatalogChallenge(
  id: 'c_coco_quarter',
  tab: CatalogChallengeTab.eat,
  kind: CatalogChallengeKind.donut,
  titleKey: 'challengeEatCocoDonuts',
  progressCurrent: 1,
  progressTotal: 4,
  pointsReward: 100,
  imageAsset: 'assets/images/seed/rewards/challenge_coco_quarter.jpg',
  sortOrder: 1,
);

const _entranceComplete = AlwaysStoppedAnimation<double>(1);

const _coffee = CatalogChallenge(
  id: 'c_americano',
  tab: CatalogChallengeTab.eat,
  kind: CatalogChallengeKind.coffee,
  titleKey: 'challengeDrinkAmericano',
  progressCurrent: 9,
  progressTotal: 12,
  pointsReward: 100,
  imageAsset: 'assets/images/seed/p_square_iced_latte.jpg',
  sortOrder: 2,
);

void main() {
  testWidgets('complete challenge uses cyan earn button', (tester) async {
    await tester.pumpApp(const RewardsChallengeCard(challenge: _complete));
    await tester.pump();

    expect(find.text('Eat 4 Coco donuts'), findsOneWidget);
    expect(find.text('4/4'), findsOneWidget);
    final earn = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(RewardsEarnButton),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(earn.color, AppColors.primary);
  });

  testWidgets('donut challenge uses quarter clip progress art', (tester) async {
    await tester.pumpApp(const RewardsChallengeCard(challenge: _quarter));
    await tester.pump();

    expect(find.byType(ClipPath), findsOneWidget);
  });

  testWidgets('incomplete challenge uses grey earn button', (tester) async {
    await tester.pumpApp(const RewardsChallengeCard(challenge: _quarter));
    await tester.pump();

    expect(find.text('1/4'), findsOneWidget);
    final earn = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(RewardsEarnButton),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(earn.color, AppColors.rewardsEarnInactive);
  });

  testWidgets('gift tab shows empty copy when no gift challenges', (
    tester,
  ) async {
    await tester.pumpApp(
      RewardsChallengeList(
        entrance: _entranceComplete,
        challenges: const [_complete, _quarter, _coffee],
        giftSelected: true,
      ),
    );
    await tester.pump();

    expect(find.text('No Promotion Found'), findsOneWidget);
    expect(find.text('9/12'), findsNothing);
  });

  testWidgets('eat tab lists donut and coffee challenges', (tester) async {
    await tester.pumpApp(
      SizedBox(
        height: 800,
        child: RewardsChallengeList(
          entrance: _entranceComplete,
          challenges: const [_complete, _quarter, _coffee],
          giftSelected: false,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('4/4'), findsOneWidget);
    expect(find.text('1/4'), findsOneWidget);
    expect(find.text('9/12'), findsOneWidget);
    expect(find.text('Drink 12 cups americano'), findsOneWidget);
  });
}
