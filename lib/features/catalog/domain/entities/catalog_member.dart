class CatalogMember {
  const CatalogMember({
    required this.displayName,
    required this.subtitleKey,
    required this.avatarAsset,
    required this.tierProgressKey,
    required this.tierProgressKyats,
    required this.notificationCount,
    required this.tierCode,
    required this.pointsBalance,
    required this.pointsToNextTier,
    required this.rewardsPillCount,
    required this.tierLadderFillBp,
  });

  final String displayName;
  final String subtitleKey;
  final String avatarAsset;
  final String tierProgressKey;
  final int tierProgressKyats;
  final int notificationCount;
  final String tierCode;
  final int pointsBalance;
  final int pointsToNextTier;
  final int rewardsPillCount;
  final int tierLadderFillBp;

  CatalogMember copyWith({
    int? tierLadderFillBp,
    int? rewardsPillCount,
    int? pointsBalance,
  }) {
    return CatalogMember(
      displayName: displayName,
      subtitleKey: subtitleKey,
      avatarAsset: avatarAsset,
      tierProgressKey: tierProgressKey,
      tierProgressKyats: tierProgressKyats,
      notificationCount: notificationCount,
      tierCode: tierCode,
      pointsBalance: pointsBalance ?? this.pointsBalance,
      pointsToNextTier: pointsToNextTier,
      rewardsPillCount: rewardsPillCount ?? this.rewardsPillCount,
      tierLadderFillBp: tierLadderFillBp ?? this.tierLadderFillBp,
    );
  }
}
