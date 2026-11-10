import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/rewards/domain/rewards_ring_progress.dart';

CatalogMember _member({int fillBp = 3500}) => CatalogMember(
  displayName: 'T',
  subtitleKey: 'memberSubtitleSilver',
  avatarAsset: 'a',
  tierProgressKey: 'memberTierProgressGold',
  tierProgressKyats: 0,
  notificationCount: 0,
  tierCode: 'silver',
  pointsBalance: 680000,
  pointsToNextTier: 500,
  rewardsPillCount: 3,
  tierLadderFillBp: fillBp,
);

void main() {
  test('sweep fraction is fill basis points over 10000', () {
    expect(rewardsRingSweepFraction(_member(fillBp: 5800)), 0.58);
  });

  test('sweep clamps above 10000 bp', () {
    expect(rewardsRingSweepFraction(_member(fillBp: 20000)), 1.0);
  });
}
