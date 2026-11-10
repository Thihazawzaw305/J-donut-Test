import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/entities/catalog_member.dart';

String catalogMemberTierProgress(AppLocalizations l10n, CatalogMember member) {
  final kyats = NumberFormat('#,###').format(member.tierProgressKyats);
  final points = NumberFormat('#,###').format(member.pointsToNextTier);
  return switch (member.tierProgressKey) {
    'memberTierProgressGold' => l10n.memberTierProgressGold(points),
    'memberTierProgressSilver' => l10n.memberTierProgressSilver(kyats),
    _ => () {
      assert(() {
        debugPrint('Unknown tierProgressKey: ${member.tierProgressKey}');
        return true;
      }());
      return '';
    }(),
  };
}

String catalogString(AppLocalizations l10n, String key) {
  return switch (key) {
    'memberSubtitleEwallet' => l10n.memberSubtitleEwallet,
    'memberSubtitleSilver' => l10n.memberSubtitleSilver,
    'homeSectionSeasonal' => l10n.homeSectionSeasonal,
    'homeSectionPopular' => l10n.homeSectionPopular,
    'homeSectionOrderAgain' => l10n.homeSectionOrderAgain,
    'homeSectionDonuts' => l10n.homeSectionDonuts,
    'homeSectionBread' => l10n.homeSectionBread,
    'homeSectionCookies' => l10n.homeSectionCookies,
    'homeSectionCake' => l10n.homeSectionCake,
    'productCoconutDonut' => l10n.productCoconutDonut,
    'productMonsterBlackFlake' => l10n.productMonsterBlackFlake,
    'productChocolateBrownie' => l10n.productChocolateBrownie,
    'productFancyClover' => l10n.productFancyClover,
    'productCandyRing' => l10n.productCandyRing,
    'productHappyBloom' => l10n.productHappyBloom,
    'productButterCreamBread' => l10n.productButterCreamBread,
    'productCheeseBread' => l10n.productCheeseBread,
    'productBreadSticks' => l10n.productBreadSticks,
    'productButterBiscuit' => l10n.productButterBiscuit,
    'productButtercake10' => l10n.productButtercake10,
    'productButtercake6' => l10n.productButtercake6,
    'productJbitesChocolate' => l10n.productJbitesChocolate,
    'productCoconutDescription' => l10n.productCoconutDescription,
    'productMonsterDescription' => l10n.productMonsterDescription,
    'productBrownieDescription' => l10n.productBrownieDescription,
    'productFancyCloverDescription' => l10n.productFancyCloverDescription,
    'productGenericDonutDescription' => l10n.productGenericDonutDescription,
    'productBreadDescription' => l10n.productBreadDescription,
    'productCookieDescription' => l10n.productCookieDescription,
    'productCakeDescription' => l10n.productCakeDescription,
    'productJbitesDescription' => l10n.productJbitesDescription,
    'shopMyaynigone' => l10n.shopMyaynigone,
    'shopMyaynigoneAddress' => l10n.shopMyaynigoneAddress,
    'shopBoAungKyaw' => l10n.shopBoAungKyaw,
    'shopBoAungKyawAddress' => l10n.shopBoAungKyawAddress,
    'shopHledan' => l10n.shopHledan,
    'shopHledanAddress' => l10n.shopHledanAddress,
    'challengeEatCocoDonuts' => l10n.challengeEatCocoDonuts,
    'challengeDrinkAmericano' => l10n.challengeDrinkAmericano,
    _ => key,
  };
}
