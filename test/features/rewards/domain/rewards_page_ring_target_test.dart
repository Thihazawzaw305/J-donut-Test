import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/core/constants/app_dimens.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/rewards/domain/rewards_ring_progress.dart';

const _member = CatalogMember(
  displayName: 'T',
  subtitleKey: 'memberSubtitleSilver',
  avatarAsset: 'assets/x.png',
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
  test('ring target combines member sweep with display cap', () {
    final fraction = rewardsRingSweepFraction(_member);
    expect(fraction, closeTo(0.75, 0.01));
    final target = rewardsDonutRingTarget(_member);
    expect(target, closeTo(0.5625, 0.01));
    expect(target, lessThan(AppDimens.rewardsDonutDisplaySweep));
    expect(target, fraction * AppDimens.rewardsDonutDisplaySweep);
  });
}
