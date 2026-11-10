import 'package:flutter_test/flutter_test.dart';
import 'package:j_donuts_app/features/catalog/domain/entities/catalog_member.dart';
import 'package:j_donuts_app/features/catalog/presentation/catalog_strings.dart';
import 'package:j_donuts_app/l10n/app_localizations_en.dart';

void main() {
  test('catalogMemberTierProgress formats kyats from member', () {
    const member = CatalogMember(
      displayName: 'Test',
      subtitleKey: 'memberSubtitleEwallet',
      avatarAsset: 'assets/images/seed/member_avatar.png',
      tierProgressKey: 'memberTierProgressSilver',
      tierProgressKyats: 999,
      notificationCount: 0,
      tierCode: 'bronze',
      pointsBalance: 0,
      pointsToNextTier: 0,
      rewardsPillCount: 0,
      tierLadderFillBp: 0,
    );
    final l10n = AppLocalizationsEn();
    final text = catalogMemberTierProgress(l10n, member);
    expect(text, contains('999'));
    expect(text, contains('kyats left'));
  });

  test('catalogMemberTierProgress formats points for Gold tier', () {
    const member = CatalogMember(
      displayName: 'Test',
      subtitleKey: 'memberSubtitleEwallet',
      avatarAsset: 'assets/images/seed/member_avatar.png',
      tierProgressKey: 'memberTierProgressGold',
      tierProgressKyats: 50001,
      notificationCount: 0,
      tierCode: 'bronze',
      pointsBalance: 0,
      pointsToNextTier: 1290,
      rewardsPillCount: 0,
      tierLadderFillBp: 0,
    );
    final l10n = AppLocalizationsEn();
    final text = catalogMemberTierProgress(l10n, member);
    expect(text, '1,290 points left to become Gold member');
  });

  test('catalogMemberTierProgress returns empty for unknown tier key', () {
    const member = CatalogMember(
      displayName: 'Test',
      subtitleKey: 'memberSubtitleEwallet',
      avatarAsset: 'x',
      tierProgressKey: 'unknownTierKey',
      tierProgressKyats: 100,
      notificationCount: 0,
      tierCode: 'bronze',
      pointsBalance: 0,
      pointsToNextTier: 0,
      rewardsPillCount: 0,
      tierLadderFillBp: 0,
    );
    final l10n = AppLocalizationsEn();
    expect(catalogMemberTierProgress(l10n, member), isEmpty);
  });
}
