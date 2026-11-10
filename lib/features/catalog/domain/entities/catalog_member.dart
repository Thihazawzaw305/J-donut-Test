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
}
