enum RewardsTier { silver, gold, platinum }

RewardsTier tierFromCode(String code) => switch (code) {
      'silver' => RewardsTier.silver,
      'gold' => RewardsTier.gold,
      'platinum' => RewardsTier.platinum,
      _ => RewardsTier.silver,
    };

bool isTierReached(String currentCode, RewardsTier step) {
  final current = tierFromCode(currentCode);
  return current.index >= step.index;
}
